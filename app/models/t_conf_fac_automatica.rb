# == Schema Information
#
# Table name: t_conf_fac_automaticas
#
#  id                       :bigint           not null, primary key
#  nombre_ciclo_facturacion :string
#  fecha_inicio             :date
#  t_tipo_cliente_id        :bigint
#  t_periodo_id             :bigint
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  estatus                  :integer
#  user_id                  :bigint
#

class TConfFacAutomatica < ApplicationRecord
  belongs_to :t_tipo_cliente
  belongs_to :t_periodo
  belongs_to :user

  has_many :t_factura_recargos, dependent: :destroy
  has_many :t_recargos, through: :t_factura_recargos
  
  has_many :t_factura_servicios, dependent: :destroy
  has_many :t_tarifa_servicios, through: :t_factura_servicios
  
  has_many :t_factura_tarifas, dependent: :destroy
  has_many :t_tarifas, through: :t_factura_tarifas

  validates :nombre_ciclo_facturacion, presence: {
    message: "|El nombre del ciclo de facturación no puede estar vacío"
  }
  validates :fecha_inicio, presence: {
    message: "|La fecha de inicio de facturación no puede estar vacía"
  }
  validates :t_tipo_cliente_id, presence: {
    message: "|El tipo de cliente no puede estar vacío"
  }
  validates :t_periodo_id, presence: {
    message: "|El periodo no puede estar vacío"
  }


  def terminar_tareas_actuales
    scheduler = Rufus::Scheduler.singleton
    scheduler.jobs(tag: self.job_tag).each do |job|
      job.unschedule
      job.kill      
    end
  end

  def job_tag
    "fac_auto#{self.id}"
  end

  def schedule_invoices
    scheduler = Rufus::Scheduler.singleton
    configuracion = TConfFacAutomatica.find(self.id)
    if self.estatus == 1
      # scheduler.at "#{configuracion.fecha_inicio} 0000" do |j0b|
      scheduler.in '2s' do |j0b|
      # scheduler.in '1m' do |j0b|
        create_invoices(j0b)

        # create_invoices(j0b, true)
        # scheduler.schedule_every '5m', :tags => self.job_tag do |job|
        #   create_invoices(job)
        # end

        # scheduler.schedule_every '1month' do |job|
        scheduler.schedule_every configuracion.t_periodo.translate_type_to_schedule, tags: self.job_tag do |job|
          create_invoices(job)
        end
      end
    end
  end

  def create_invoices(job, revisar_reenvios = false)
    facturas_creadas = 0
    facturas_con_monto_0 = 0
    # debugger
    configuracion_actual = TConfFacAutomatica.find(self.id)

    if configuracion_actual.estatus != 1
      puts 'Terminating jobs!'
      job.unschedule if job.scheduled?
      job.kill if job.running?
    else
      puts 'Job is up yet!'
      puts "Job id: #{job.id}"
    end

    #ActiveRecordRelation
    t_resolucions = TResolucion.where(t_tipo_cliente: configuracion_actual.t_tipo_cliente)
    cantidad_resoluciones = t_resolucions.count
    #Descomentar cuando tenga el campo de resoluciones activas
    #t_resolucions = TResolucion.where(t_tipo_cliente: configuracion_actual.t_tipo_cliente, activo: true)
    ##################################################################################################

    #Se busca cada resolucion por su numero de resolucion
    #Actualmente solo se usa para los emisores, esta parte esta sujeto a cambios
    numero_resoluciones = t_resolucions.pluck(:resolucion)

    #Central de valores/ Bolsa de valores/ Casa de valores
    query_casa_de_valores = [3,15,16]
    #Sociedades de inversion
    query_sociedades_inversion = [3,9]
    #Emisores/Valores registrados
    query_emisores = [5]

    if query_casa_de_valores.include?(configuracion_actual.t_tipo_cliente_id)
      codigos_seri = t_resolucions.joins(:t_cliente).pluck(:"t_clientes.codigo")
      resoluciones_x_monto_casa_valores = configuracion_actual.call_query_monto_casa_valores(codigos_seri)
    elsif query_sociedades_inversion.include?(configuracion_actual.t_tipo_cliente_id)
      codigos_seri = t_resolucions.joins(:t_cliente).pluck(:"t_clientes.codigo")
      resoluciones_x_monto_sociedades_inversion = configuracion_actual.call_query_monto_sociedades_inversion(codigos_seri)
    elsif query_emisores.include?(configuracion_actual.t_tipo_cliente_id)
      resoluciones_x_factura_x_monto = configuracion_actual.call_query_monto_emisores(numero_resoluciones)
    end

    ##################################################################################################


    t_resolucions.each do |t_resolucion|
      t_factura = TFactura.new(
        fecha_notificacion: configuracion_actual.fecha_inicio,
        fecha_vencimiento: configuracion_actual.fecha_inicio + 1.month,
        recargo_desc: '-',
        itbms: 0,
        importe_total: 0,
        pendiente_ts: 0,
        tipo: '-',
        next_fecha_recargo: Date.today + 1.month,
        monto_emision: 0,
        justificacion: configuracion_actual.nombre_ciclo_facturacion,
        automatica: true,
        t_estatus: TEstatus.find_by(descripcion: 'Disponible'),
        t_periodo: configuracion_actual.t_periodo,
        # t_recargos: configuracion_actual.t_recargos,
        t_resolucion: t_resolucion,
        user: configuracion_actual.user
      )

      configuracion_actual.t_recargos.each do |t_recargo|
        t_factura.t_recargo_facturas.build(
          cantidad: 1,
          precio_unitario: t_recargo.tasa,
          t_recargo: t_recargo
        )
      end

      configuracion_actual.t_tarifa_servicios.each do |t_tarifa_servicio|
        t_factura.t_factura_detalles.build(
          cantidad: 1,
          cuenta_desc: t_tarifa_servicio.descripcion,
          precio_unitario: t_tarifa_servicio.precio,
          t_factura: t_factura,
          t_tarifa_servicio: t_tarifa_servicio
        )
      end
      #Si una configuracion automatica no tiene servicios (tarifa_servicios) no se crearan facturas_detalles, lo cual ocasionara que el bloque de abajo genere error, es necesario validar para que las configuraciones automaticas tengan servicios

      ################ Modificamos el precio unitario solamente #######################
      
      unless resoluciones_x_monto_casa_valores.nil?
        if resoluciones_x_monto_casa_valores.count > 0 
          #Hacemos match con el codigo_seri nuevamente y le cambiamos el precio unitario por el monto final (Ya multiplicado por su respectiva tarifa)
          resolucion_seleccionada = resoluciones_x_monto_casa_valores.select{|r| r["CODIGO_SERI"] == t_resolucion.t_cliente.codigo} 
              
          t_factura.t_factura_detalles.last.precio_unitario = resolucion_seleccionada.first["MONTO"].to_f.round(2) unless resolucion_seleccionada.blank?
          
          # if t_resolucion.id == 1
          #   # debugger
          #   #Valor de prueba
          #   # t_factura.t_factura_detalles.last.precio_unitario = t_factura.t_factura_detalles.last.precio_unitario + 1000
          # end
        end
      end

      unless resoluciones_x_monto_sociedades_inversion.nil?
        if resoluciones_x_monto_sociedades_inversion.count > 0
          #Hacemos match con el codigo_seri nuevamente y le cambiamos el precio unitario por el monto final (Ya multiplicado por su respectiva tarifa)
          # debugger if t_resolucion.id == 5
          resolucion_seleccionada = resoluciones_x_monto_sociedades_inversion.select{|r| r["CODIGO_SERI"] == t_resolucion.t_cliente.codigo}

          t_factura.t_factura_detalles.last.precio_unitario = resolucion_seleccionada.first["MONTO"].to_f.round(2) unless resolucion_seleccionada.blank?
          # if t_factura.t_factura_detalles.last.precio_unitario == 0
          #   #Se salta para evitar generar una factura con monto 0
          #   facturas_con_monto_0 += 1
          #   next 
          # end

          # if t_resolucion.id == 5 #47
          #   # debugger
          #   # t_factura.t_factura_detalles.last.precio_unitario = t_factura.t_factura_detalles.last.precio_unitario + 1000
          # end
        end
      end

      unless resoluciones_x_factura_x_monto.nil?
        if resoluciones_x_factura_x_monto.count > 0
          #Se pidio que deben haber 2 items, uno con el monto rotativo y el otro con el monto no rotativo
          #Solo retornara 4 resoluciones, hay que ajustar el formato de las resoluciones debido a que se usa la resolucion para conectar la informacion que trae Oracle con la aplicacion de CxC
          resolucion_seleccionada = resoluciones_x_factura_x_monto.select{|r| r["RESOLUCION"] == t_resolucion.resolucion} 

          next if resolucion_seleccionada.blank?
          
          ultima_factura = t_factura.t_factura_detalles.last
          ultima_factura.precio_unitario = resolucion_seleccionada.first["MONTO_ROTATIVO_FINAL"].to_f.round(2)
          last_name = ultima_factura.cuenta_desc
          ultima_factura.cuenta_desc += " rotativo"
          
          t_factura.t_factura_detalles.build(
            cantidad: 1,
            cuenta_desc: last_name + " no rotativo",
            precio_unitario: resolucion_seleccionada.first["MONTO_NO_ROTATIVO_FINAL"].to_f,
            t_factura_id: ultima_factura.t_factura_id,
            t_tarifa_servicio_id: ultima_factura.t_tarifa_servicio_id
          )
        end
      end
      
          
      ############################################################################################
      no_generar_factura = true
      
      if revisar_reenvios

        if query_emisores.include?(configuracion_actual.t_tipo_cliente_id)
          # debugger
          anterior_factura_detalle_rotativo = TFactura.where(justificacion: configuracion_actual.nombre_ciclo_facturacion).joins(t_resolucion: :t_cliente).where("t_resolucions.resolucion = '#{t_resolucion.resolucion}' and t_resolucions.t_cliente_id = '#{t_resolucion.t_cliente_id}'").order("created_at ASC").last.t_factura_detalles.where("cuenta_desc like ?", '%rotativo%').first

          nueva_factura_detalle_rotativo = t_factura.t_factura_detalles.select{|e| e.cuenta_desc.include?('rotativo')}.first

          diferencia_rotativa = nueva_factura_detalle_rotativo.precio_unitario.round(2) - anterior_factura_detalle_rotativo.precio_unitario.round(2)
          if t_resolucion.resolucion == "SMV-295-13"
            # debugger
            diferencia_rotativa = diferencia_rotativa + 1000
          end

          anterior_factura_detalle_no_rotativo = TFactura.where(justificacion: configuracion_actual.nombre_ciclo_facturacion).joins(t_resolucion: :t_cliente).where("t_resolucions.resolucion = '#{t_resolucion.resolucion}' and t_resolucions.t_cliente_id = '#{t_resolucion.t_cliente_id}'").order("created_at ASC").last.t_factura_detalles.where("cuenta_desc like ?", '%no rotativo%').first

          nueva_factura_detalle_no_rotativo = t_factura.t_factura_detalles.select{|e| e.cuenta_desc.include?('no rotativo')}.first

          diferencia_no_rotativa = nueva_factura_detalle_no_rotativo.precio_unitario.round(2) - anterior_factura_detalle_no_rotativo.precio_unitario.round(2)

          diferencia = diferencia_rotativa + diferencia_no_rotativa
          if diferencia > 0
            nueva_factura_detalle_rotativo.precio_unitario = diferencia_rotativa
            nueva_factura_detalle_no_rotativo.precio_unitario = diferencia_no_rotativa
            no_generar_factura = false
          elsif diferencia < 0
            # debugger
            puts "Sobrante"
            #Se genera una nota de credito
          end
        else
          # debugger if t_resolucion.id == 5

          primera_factura = TFactura.where(justificacion: configuracion_actual.nombre_ciclo_facturacion).joins(t_resolucion: :t_cliente).where("t_resolucions.resolucion = '#{t_resolucion.resolucion}' and t_resolucions.t_cliente_id = '#{t_resolucion.t_cliente_id}'").order("created_at ASC").last
          next if primera_factura.nil?
          diferencia = t_factura.t_factura_detalles.first.precio_unitario.round(2) - primera_factura.t_factura_detalles.first.precio_unitario.round(2)
          t_factura.t_factura_detalles.select{|e| e.cuenta_desc.include?('rotativo')}

          if diferencia > 0
            # debugger
            #Se genera otra factura para cubrir el monto que falta
            t_factura.t_factura_detalles.first.precio_unitario = diferencia
            no_generar_factura = false
          elsif diferencia < 0
            # debugger
            puts "Sobrante"
            #Se genera una nota de credito
          end

        end

      end
      #Se salta para evitar factura, no_generar_factura sera falso si el monto nuevo es igual al de la ultima factura realizada, lo cual significaria que no hubo reenvios
      # puts "Facturas creadas: #{facturas_creadas} || Resoluciones: #{cantidad_resoluciones}"
      # puts "Facturas con monto 0 (No creadas): #{facturas_con_monto_0}"
      next if (revisar_reenvios && no_generar_factura)
      t_factura.t_factura_detalles.first.precio_unitario =  t_factura.t_factura_detalles.first.precio_unitario.round(2)
      t_factura.recargo = t_factura.calculate_total_surcharge
      t_factura.pendiente_fact = t_factura.calculate_pending_payment(true)
      t_factura.total_factura = t_factura.calculate_total

      if t_factura.total_factura == 0
        #Se salta para evitar generar una factura con monto 0
        facturas_con_monto_0 += 1
        next 
      end

      if t_factura.save!
        facturas_creadas += 1
        
        # debugger
        puts "\n" * 5 + '¡Facturas automáticas creadas!' + "\n"
        # puts "Facturas creadas: #{facturas_creadas} || Resoluciones: #{cantidad_resoluciones}"
        # puts "Facturas con monto 0 (No creadas): #{facturas_con_monto_0}"
        t_factura_detalles = t_factura.t_factura_detalles
        if t_factura_detalles.any? && (t_factura_detalles.first.t_tarifa_servicio.tipo.nil? ? t_factura_detalles.first.t_tarifa_servicio.tipo : t_factura_detalles.first.t_tarifa_servicio.tipo.downcase ) == 'ts'
          t_factura.schedule_custom_percent_monthly_surcharge(
            TConfiguracionRecargoT.take.try(:tasa) || 0
          )
        end

        t_factura.t_recargos.each do |t_recargo|
          t_factura.schedule_surcharge(t_recargo)
        end
      else
        puts "\n" * 5 + '¡La factura no se pudo crear!'
      end
    end
    puts "Facturas creadas: #{facturas_creadas} || Resoluciones: #{cantidad_resoluciones}"
    puts "Facturas con monto 0 (No creadas): #{facturas_con_monto_0}"
    puts "Total de facturas:  #{facturas_con_monto_0 + facturas_creadas}"
    puts self.job_tag + " -> " + self.updated_at.strftime("%s") #+ " -- " + jobs.inspect()
  end

  def call_query_estatus_juridico(resoluciones)
    contador = 1
    formato_resoluciones = ""

    resoluciones.each do |resolucion|
      if contador == 1
        formato_resoluciones = "'#{resolucion}'"
      # elsif contador == resoluciones.count
      #   formato_resoluciones = "#{formato_resoluciones}, '#{resolucion}'"
      else
        formato_resoluciones = "#{formato_resoluciones}, '#{resolucion}'"
      end
      contador = contador + 1 
    end

    formato_resoluciones = "'CNV-155-07', 'CNV-245-09', 'CNV-224-05', 'CNV-251-11'"
    con=OCI8.new("JMEDINA","abc123","(DESCRIPTION=(ADDRESS_LIST = (ADDRESS = (PROTOCOL = TCP)(HOST = 35.171.169.71)(PORT = 1521)))(CONNECT_DATA=(SID=orcl)))")

    statement= 
    "Select
      upper(a.nombre_comercial) casa,
      a.n_resolucion resolucion,
      a.estado estado
      from
        smv_app.smv_gral_entidad a
      where a.n_resolucion in (#{formato_resoluciones})
        and not (a.estado = 4 or a.estado = 7)"

    resoluciones_activas = []
    cursor = con.parse(statement)
    cursor.exec

    # cursor.fetch() {|row| output_array.push("casa" => "#{row[0]}","resolucion" => "#{row[1]}", "estado" => "#{row[2]}")}

    cursor.fetch() {|row| resoluciones_activas.push(row[1])}
    return resoluciones_activas.blank? ? resoluciones_activas = nil : resoluciones_activas
  end

  def call_query_estatus_natural(resoluciones) 
    contador = 1
    formato_resoluciones = ""

    resoluciones.each do |resolucion|
      if contador == 1
        formato_resoluciones = "'#{resolucion}'"
      # elsif contador == resoluciones.count
      #   formato_resoluciones = "#{formato_resoluciones}, '#{resolucion}'"
      else
        formato_resoluciones = "#{formato_resoluciones}, '#{resolucion}'"
      end
      contador = contador + 1 
    end

    formato_resoluciones = "'CNV-067-08', 'CNV-420-01', 'CNV-108-08', 'CNV-421-01', 'CNV-429-01', 'CNV-120-08'"

    con=OCI8.new("JMEDINA","abc123","(DESCRIPTION=(ADDRESS_LIST = (ADDRESS = (PROTOCOL = TCP)(HOST = 35.171.169.71)(PORT = 1521)))(CONNECT_DATA=(SID=orcl)))")
    statement=
    "Select
      a.estado,
      a.nombre,
      a.apellido,
      a.resolucion
      from
        smv_app.SMV_PERSONA_NATURAL a
      where not
        (a.estado = 'Expirada' or a.estado = 'Cancelada')
      and 
        a.resolucion in (#{formato_resoluciones})"

    

    resoluciones_activas = []
    cursor = con.parse(statement)
    cursor.exec
    # cursor.fetch() {|row| output_array.push("estado" => "#{row[0]}","nombre" => "#{row[1]}", "apellido" => "#{row[2]}", "resolucion" => "#{row[3]}")}
    cursor.fetch() {|row| resoluciones_activas.push(row[3])}
    return resoluciones_activas.blank? ? resoluciones_activas = nil : resoluciones_activas
  end

  #Juridico
  def call_query_monto_casa_valores(codigos_seri)
    #El periodo que se coloca es el anio anterior del momento en el que hace trigger este metodo 
    anio = DateTime.now.strftime('%Y').to_i - 1   

    final_output = []
    codigos_seri.each do |seri|
      final_output.push("CODIGO_SERI" => "#{seri.to_i}", "MONTO" => 0)
    end

    con=OCI8.new("JMEDINA","abc123","(DESCRIPTION=(ADDRESS_LIST = (ADDRESS = (PROTOCOL = TCP)(HOST = 35.171.169.71)(PORT = 1521)))(CONNECT_DATA=(SID=orcl)))")

    # statement=
    #   "Select
    #     a.CODIGO_ENTIDAD Codigo_SERI,
    #     sum(  round(a.MONTO,2) ) Monto,
    #     upper(c.Nombre_comercial ) Casa
    #   from
    #     smv_app.SMV_DS01_TRANSACCIONES a,
    #     smv_app.smv_001 b ,
    #     smv_app.SMV_GRAL_ENTIDAD c,
    #     smv_app.SMV_DOCUMENTOS_XML d
    #   where a.periodo >  to_date ('20160331','yyyymmdd')
    #     and a.CODIGO_ENTIDAD = d.CODIGO_ENTIDAD
    #     and a.ID_DOCUMENTO_XML = d.ID
    #     and a.codigo_entidad = c.id_casa_valor
    #     and to_char(a.periodo,'yyyy') = nvl(#{anio}, to_char(a.periodo,'yyyy'))
    #     and b.codigo = a.ID_TIPO_VALOR
    #     and c.ENT_TST='N'
    #     and d.ESTATUS=4
    #   group  by
    #     a.CODIGO_ENTIDAD,
    #     c.Nombre_comercial
    #   ORDER BY
    #     2,3"

    if Date.today.strftime("%m").to_i <= 3
      primer_periodo = (DateTime.now.strftime('%Y').to_i - 1).to_s + "01"  
      segundo_periodo = (DateTime.now.strftime('%Y').to_i - 1).to_s + "03" 
    elsif Date.today.strftime("%m").to_i <= 6
      primer_periodo = (DateTime.now.strftime('%Y').to_i - 1).to_s + "04"  
      segundo_periodo = (DateTime.now.strftime('%Y').to_i - 1).to_s + "06"
    elsif Date.today.strftime("%m").to_i <= 9
      primer_periodo = (DateTime.now.strftime('%Y').to_i - 1).to_s + "07"  
      segundo_periodo = (DateTime.now.strftime('%Y').to_i - 1).to_s + "09"
    else
      primer_periodo = (DateTime.now.strftime('%Y').to_i - 1).to_s + "10"  
      segundo_periodo = (DateTime.now.strftime('%Y').to_i - 1).to_s + "12"
    end

    statement=
      "Select
        a.CODIGO_ENTIDAD Codigo_SERI,
        sum(  round(a.MONTO,2) ) Monto,
        upper(c.Nombre_comercial ) Casa
      from
        smv_app.SMV_DS01_TRANSACCIONES a,
        smv_app.smv_001 b ,
        smv_app.SMV_GRAL_ENTIDAD c,
        smv_app.SMV_DOCUMENTOS_XML d
      where a.periodo >  to_date ('20160331','yyyymmdd')
        and a.CODIGO_ENTIDAD = d.CODIGO_ENTIDAD
        and a.ID_DOCUMENTO_XML = d.ID
        and a.codigo_entidad = c.id_casa_valor
        and to_char(a.periodo,'yyyymm') BETWEEN nvl(#{primer_periodo}, to_char(a.periodo,'yyyymm')) and nvl(#{segundo_periodo}, to_char(a.periodo,'yyyymm'))
        and b.codigo = a.ID_TIPO_VALOR
        and c.ENT_TST='N'
        and d.ESTATUS=4
      group  by
        a.CODIGO_ENTIDAD,
        c.Nombre_comercial
      ORDER BY
        2,3"

        

    output_array = []
    cursor = con.parse(statement)
    cursor.exec
    cursor.fetch() {|row| output_array.push("CODIGO_SERI" => "#{row[0]}", "MONTO" => "#{row[1]}", "CASA" => "#{row[2]}")}

    # debugger

    output_array.sort_by{|e| e["CODIGO_SERI"]}.each do |output|
      selected_client = nil

      selected_client = final_output.select{|e| e["CODIGO_SERI"].to_i.to_s == output["CODIGO_SERI"].to_i.to_s}.first
      # debugger
      next if selected_client.blank?
      monto_total = 0
      cliente = nil
      # cliente = TCliente.find_by_codigo(selected_client["CODIGO_SERI"])
      # cliente = TCliente.where(codigo: selected_client["CODIGO_SERI"]).joins(:t_resolucions).where("t_resolucions.t_tipo_cliente_id = nil")
      # debugger
      cliente = TCliente.where(codigo: selected_client["CODIGO_SERI"]).includes(:t_resolucions).where.not(t_resolucions: {t_tipo_cliente_id: nil}).first
      #Si no se encuentra el cliente con ese codigo SERI o si no posee resoluciones
      next if (cliente.nil? || cliente.t_resolucions.count == 0) 
      #Asumiendo que cada cliente tiene solo una resolucion (Solo clientes que son emisores pueden tener varias resoluciones)
      case cliente.t_resolucions.first.t_tipo_cliente.codigo 
        when "9"
          #BOLSA DE VALORES AUTORREGULADA
          monto = output["MONTO"].to_f
          tarifa = monto * 0.000020
          ( tarifa < 10000 ? tarifa = 10000 : ( tarifa > 100000 ? tarifa = 100000 : tarifa) )
          # monto_total = monto + tarifa
          monto_total = tarifa
          #Prueba de consola, cambiar la tarifa a valores hipoteticos
          # tarifa = 100000323
          # ( tarifa < 10000 ? tarifa = 10000 : ( tarifa > 100000 ? tarifa = 100000 : tarifa) )
        when "10"
          #CASA DE VALORES
          monto = output["MONTO"].to_f
          tarifa = monto * 0.000025
          ( tarifa < 15000 ? tarifa = 15000 : ( tarifa > 100000 ? tarifa = 100000 : tarifa) )
          # monto_total = monto + tarifa 
          monto_total = tarifa              
             
        when "8"
          #CENTRAL DE VALORES AUTORREGULADAS
          monto = output["MONTO"].to_f  
          tarifa = monto * 0.000010
          ( tarifa < 5000 ? tarifa = 5000 : ( tarifa > 100000 ? tarifa = 100000 : tarifa) )
          # monto_total = monto + tarifa
          monto_total = tarifa
      end
      
      selected_client["MONTO"] = selected_client["MONTO"] + monto_total

    end

    return final_output
  end

  #Juridico
  def call_query_monto_sociedades_inversion(codigos_seri)
    #Pasamos el anio anterior al query
    anio = DateTime.now.strftime('%Y').to_i - 1

    #Aqui guardamos cada monto con su respectivo cliente, el cual sera linkeado a traves de su codigo_seri
    final_output = []
    #Creamos un espacio para cada cliente por su codigo_seri
    codigos_seri.each do |seri|
      final_output.push("CODIGO_SERI" => "#{seri.to_i}", "MONTO" => 0)
    end

    #Hacemos la conexion con la base de datos de la SMV
    con=OCI8.new("JMEDINA","abc123","(DESCRIPTION=(ADDRESS_LIST = (ADDRESS = (PROTOCOL = TCP)(HOST = 35.171.169.71)(PORT = 1521)))(CONNECT_DATA=(SID=orcl)))")

    statement=
      "SELECT  SVN.CODIGO_ENTIDAD  Codigo_SERI ,
        Upper( SGE.NOMBRE_COMERCIAL) Nombre,
        to_char(SVN.PERIODO,'yyyy') Anio,
        round( avg (SVN.VALOR_NETO),2)  promedio ,
        count(SVN.MES) Mes_reportados
      FROM
        smv_app.SMV_SDI_IAS_VALOR_NETO SVN ,
        smv_app.SMV_GRAL_ENTIDAD SGE ,
        smv_app.SMV_DOCUMENTOS_XML d
      WHERE  TO_CHAR(svn.PERIODO,'YYYY') =#{anio}
        and  SVN.CODIGO_ENTIDAD = SGE.ID_CASA_VALOR
        and  SVN.CODIGO_ENTIDAD   = D.CODIGO_ENTIDAD
        and  SVN.ID_DOCUMENTO_XML = d.ID
        and  d.ESTATUS=4
      group  by
        Upper( SGE.NOMBRE_COMERCIAL) ,
        SVN.CODIGO_ENTIDAD  ,
        to_char(SVN.PERIODO,'yyyy')
      ORDER BY
        2"

    #En output_array guardamos todo lo que nos retorna el query
    output_array = []
    cursor = con.parse(statement)
    cursor.exec
    cursor.fetch() {|row| output_array.push("CODIGO_SERI" => "#{row[0]}", "NOMBRE" => "#{row[1]}", "ANIO" => "#{row[2]}", "PROMEDIO" => "#{row[3]}", "MES_REPORTADOS" => "#{row[4]}")}

    ###########################################################

    #Recorremos el output_array
    output_array.sort_by{|e| e["CODIGO_SERI"]}.each do |output|
      #Reiniciamos el cliente seleccionado por si acaso, en caso de no hacerlo puede crear conflictos con los montos finales
      selected_client = nil
      #Hacemos match con el codigo SERI que trae de la base de datos de la SMV(Oracle) junto a los codigos_seri de la aplicacion de CxC

      #Los codigos SERI que retorna la base de datos de Oracle tienen formatos parecidos a "080, 019, 005". En cambio en CxC se guardan como "80", "19" y "5". Debido a esto eliminamos los 0's para que puedan hacer match
      selected_client = final_output.select{|e| e["CODIGO_SERI"] == output["CODIGO_SERI"].to_i.to_s}.first
      #En caso de que no haga match, se salta (Se salta para poder seguir probando el metodo pero en teoria deberia existir en la base de datos de ambos SMV y CxC)
      next if selected_client.blank?

      monto_total = 0
      cliente = nil
      cliente = TCliente.find_by_codigo(selected_client["CODIGO_SERI"])
      #Si no se encuentra el cliente con ese codigo SERI o si no posee resoluciones
      next if (cliente.nil? || cliente.t_resolucions.count == 0) 
      #Asumiendo que cada cliente tiene solo una resolucion (Solo clientes que son emisores pueden tener varias resoluciones)

      monto = output["PROMEDIO"].to_f
      tarifa = monto * 0.000020
      ( tarifa < 1000 ? tarifa = 1000 : ( tarifa > 20000 ? tarifa = 20000 : tarifa) )
      # monto_total = monto + tarifa
      monto_total = tarifa


      selected_client["MONTO"] = selected_client["MONTO"] + monto_total

    end

    ###########################################################

    return final_output
  end

  def call_query_monto_emisores(resoluciones)
    # debugger
    #Se nesecita saber solo las de Octubre/Noviembre/Diciembre - 10/11/12 del anio anterior (del momento en que se esta facturando, anio_actual menos 1)
    periodo = (DateTime.now.strftime('%Y').to_i - 1).to_s + "12"

    con=OCI8.new("JMEDINA","abc123","(DESCRIPTION=(ADDRESS_LIST = (ADDRESS = (PROTOCOL = TCP)(HOST = 35.171.169.71)(PORT = 1521)))(CONNECT_DATA=(SID=orcl)))")

    statement=
          "select 
            a.CODIGO_ENTIDAD,
            UPPER( c.Nombre_comercial) Ente ,
            upper (c.sitio_web) Sector ,
            a.resolucion ,
            a.Fecha_resolucion ,
            upper(a.titulo_valor) Titulo ,
            a.monto_tot_registrado Monto_emision ,
            a.acciones_registrada ,
            a.acciones_circulacion ,
            s.serie ,
            s.fecha_oferta ,
            s.fecha_vencimiento Fecha_vencimiento_serie ,
            to_char (s.fecha_vencimiento,'yyyymm') periodo_vence ,
            s.MONTO Monto_inicial ,
            s.monto_circulacion,
            a.titulo_valor,
            a.periodo
          from
            smv_app.smv_emi_f3_emision  a,
            smv_app.SMV_GRAL_ENTIDAD c ,
            smv_app.smv_emi_f3_series s ,
            smv_app.smv_documentos_xml  d
          where   a.codigo_entidad = c.id_casa_valor
            and    a.CODIGO_ENTIDAD = s.codigo_entidad
            and    a.PERIODO = s.PERIODO
            and TO_CHAR (A.PERIODO,'YYYYMM') = '#{periodo}'
            and    a.ID_DOCUMENTO_XML = s.ID_DOCUMENTO_XML
            and    a.resolucion  = s.RESOLUCION
            and  a.CODIGO_ENTIDAD = D.CODIGO_ENTIDAD
            and  a.ID_DOCUMENTO_XML = d.ID
            and  d.ESTATUS=4
          order by
            2,3"
    #Agregar cuango tengamos las resoluciones estandarizados
    #Se puede optimizar trayendo solo las resoluciones que querramos en vez de traerlo todo y despues filtrar

    #and    TO_CHAR (A.PERIODO,'YYYYMM') in (#{periodo_final})

    #         and a.codigo_entidad in ('2788')
    #         and  upper(a.titulo_valor) in ('ACCIONES PREFERIDAS ACUMULATIVAS')
    #         and  upper(a.titulo_valor) in (#{emisores_tipo_rotativo})

    output_array = []
    cursor = con.parse(statement)
    cursor.exec
    cursor.fetch() {|row| output_array.push("CODIGO_SERI" => "#{row[0]}", "ENTE" => "#{row[1]}", "RESOLUCION" => "#{row[3].strip}", "MONTO_EMISION" => "#{row[6]}", "SERIE" => "#{row[9]}", "MONTO_INICIAL" => "#{row[13]}", "MONTO_CIRCULACION" => "#{row[14]}", "TITULO_VALOR" => "#{row[15]}", "PERIODO" => "#{row[16]}")}


    statement=
          "select 
            UPPER( c.Nombre_comercial) Ente ,
            a.resolucion ,
            upper(a.titulo_valor) Titulo ,
            sum(  a.acciones_circulacion ) Total_acciones_circulacion,
            sum(Monto_circulacion ) totalMonto_circulacion ,sum(s.valor_mercado ) Valor_mercado
          from  
            smv_app.smv_emi_f3_emision  a,  
            smv_app.SMV_GRAL_ENTIDAD c , 
            smv_app.smv_emi_f3_series s , 
            smv_app.smv_documentos_xml d
          where   
            a.codigo_entidad = c.id_casa_valor
            and    TO_CHAR (A.PERIODO,'YYYYMM') = '#{periodo}'
            and    a.CODIGO_ENTIDAD = s.codigo_entidad
            and    a.PERIODO = s.PERIODO
            and    a.ID_DOCUMENTO_XML = s.ID_DOCUMENTO_XML
            and    a.resolucion  = s.RESOLUCION
            and  upper(a.titulo_valor)  like ('%ACC%')
            and  a.CODIGO_ENTIDAD = D.CODIGO_ENTIDAD
            and  a.ID_DOCUMENTO_XML = d.ID
            and  d.ESTATUS=4
          group  by 
            UPPER( c.Nombre_comercial) ,
            a.resolucion ,
            upper(a.titulo_valor) 
          order by 
            1,2"

    output_array_emisores_acciones = []
    cursor = con.parse(statement)
    cursor.exec
    cursor.fetch() {|row| output_array_emisores_acciones.push("ENTE" => "#{row[0]}", "RESOLUCION" => "#{row[1]}", "TITULO" => "#{row[2].strip}", "TOTAL_ACCIONES_CIRCULACION" => "#{row[3]}", "TOTAL_MONTO_CIRCULACION" => "#{row[4]}", "VALOR_MERCADO" => "#{row[5]}")}



    #resoluciones de prueba
    # resoluciones = ['SMV No.618-17', '322-18', 'CNV-913-95', 'CNV-262-11', 'SMV-295-13']
    # resoluciones = ['SMV-512-2013', 'SMV-07-2013', 'SMV-11-2016', 'SMV-669-2017']
    final_output = []

    #Pasamos por cada resolucion
    resoluciones.each do |resolucion|
      # debugger
      final_output.push(
        "RESOLUCION" => "#{resolucion}", 
        "MONTO_ROTATIVO" => 0, 
        "MONTO_ROTATIVO_FINAL" => 0,
        "MONTO_NO_ROTATIVO" => 0,
        "MONTO_NO_ROTATIVO_FINAL" => 0)

      resolucion_matches = []
      monto_rotativo = 0
      monto_no_rotativo = 0
      monto_final_rotativo = 0
      monto_final_no_rotativo = 0
      #Se seleccionan todos aquellos que hagan match con el codigo_seri (Una emision puede tener multiples series, usamos el SERI para hacer match con la emision)
      # debugger
      #Se seleccionan todas las series que hagan match con la resolucion
      resolucion_matches = output_array.select{ |output_array| output_array["RESOLUCION"] == resolucion}
      
      # debugger
      unless resolucion_matches.blank?
        #Pasamos por cada serie y verificamos si el nombre de la serie contiene un "#", los agrupamos entre los que tienen y los que no tienen "#"
        resolucion_matches.each do |resolucion_match|
          #Si el nombre de la serie posee un # significa que es rotativo
          if resolucion_match["SERIE"].include?("#")
            monto_rotativo = monto_rotativo + resolucion_match["MONTO_CIRCULACION"].to_f
          else
            monto_no_rotativo = monto_no_rotativo + resolucion_match["MONTO_CIRCULACION"].to_f
          end

          resolucion_seleccionada = final_output.select{|e| e["RESOLUCION"] == resolucion_match["RESOLUCION"]}.first
          resolucion_seleccionada["MONTO_ROTATIVO"] += monto_rotativo
          resolucion_seleccionada["MONTO_NO_ROTATIVO"] += monto_no_rotativo

        end
        resolucion_seleccionada = final_output.select{|e| e["RESOLUCION"] == resolucion}.first

        #Se calculan las tarifas
        tarifa_rotativa = resolucion_seleccionada["MONTO_ROTATIVO"] * 0.000015
        ( tarifa_rotativa < 3000 ? tarifa_rotativa = 3000 : ( tarifa_rotativa > 20000 ? tarifa_rotativa = 20000 : tarifa_rotativa) )

        # tarifa_no_rotativa = monto_no_rotativo * 0.015
        tarifa_no_rotativa = resolucion_seleccionada["MONTO_NO_ROTATIVO"] * 0.000015
        ( tarifa_no_rotativa < 1000 ? tarifa_no_rotativa = 1000 : ( tarifa_no_rotativa > 20000 ? tarifa_no_rotativa = 20000 : tarifa_no_rotativa) )

        #Hay 3 escenarios
        #1: monto_final_rotativo = 0 / monto_final_no_rotativo > 0 - Emision no rotativa
        #2: monto_final_rotativo > 0 / monto_final_no_rotativo = 0 - Emision rotativa
        #3: monto_final_rotativo > 0 / monto_final_no_rotativo > 0 - Emision mixta
        #
        #Los condicionales de abajo son necesarios para que puedan ocurrir los 3 escenarios, sin ellos solo ocurriria 1 debido a que las tarifas siempre seran mayor que 0 aun si el monto es 0
        # (monto_final_rotativo = monto_rotativo + tarifa_rotativa) if resolucion_seleccionada["MONTO_ROTATIVO"] > 0
        (monto_final_rotativo = tarifa_rotativa) if resolucion_seleccionada["MONTO_ROTATIVO"] > 0

        # (monto_final_no_rotativo = monto_no_rotativo + tarifa_no_rotativa) if resolucion_seleccionada["MONTO_NO_ROTATIVO"] > 0
        (monto_final_no_rotativo = tarifa_no_rotativa) if resolucion_seleccionada["MONTO_NO_ROTATIVO"] > 0

        resolucion_seleccionada["MONTO_ROTATIVO_FINAL"] = monto_final_rotativo
        resolucion_seleccionada["MONTO_NO_ROTATIVO_FINAL"] = monto_final_no_rotativo
      end


      ######################################################################################################
      ######################################################################################################
      ######################################################################################################
      ######################################################################################################

      resolucion_matches = output_array_emisores_acciones.select{ |output_array_emisores_acciones| output_array_emisores_acciones["RESOLUCION"] == resolucion}

      unless resolucion_matches.blank?
        #Pasamos por cada serie y verificamos si el nombre de la serie contiene un "#", los agrupamos entre los que tienen y los que no tienen "#"
        resolucion_matches.each do |resolucion_match|

          #Si el nombre de la serie posee un # significa que es rotativo
          # if resolucion_match["SERIE"].include?("#")
          #   monto_rotativo = monto_rotativo + resolucion_match["MONTO_CIRCULACION"].to_f
          # else
          #   monto_no_rotativo = monto_no_rotativo + resolucion_match["MONTO_CIRCULACION"].to_f
          # end
          if resolucion_match["VALOR_MERCADO"].nil? || resolucion_match["VALOR_MERCADO"] == 0
            resolucion_match["TOTAL_MONTO_CIRCULACION"] = 1
          end

          monto_calculado = resolucion_match["TOTAL_ACCIONES_CIRCULACION"].to_f * resolucion_match["VALOR_MERCADO"].to_f

          resolucion_seleccionada = final_output.select{|e| e["RESOLUCION"] == resolucion_match["RESOLUCION"]}.first
          resolucion_seleccionada["MONTO_ROTATIVO"] += monto_calculado
          # resolucion_seleccionada["MONTO_NO_ROTATIVO"] += monto_no_rotativo

        end
        resolucion_seleccionada = final_output.select{|e| e["RESOLUCION"] == resolucion}.first

        #Se calculan las tarifas
        tarifa_rotativa = resolucion_seleccionada["MONTO_ROTATIVO"] * 0.000015
        ( tarifa_rotativa < 3000 ? tarifa_rotativa = 3000 : ( tarifa_rotativa > 20000 ? tarifa_rotativa = 20000 : tarifa_rotativa) )

        # tarifa_no_rotativa = monto_no_rotativo * 0.015
        # tarifa_no_rotativa = resolucion_seleccionada["MONTO_NO_ROTATIVO"] * 0.015
        # ( tarifa_no_rotativa < 1000 ? tarifa_no_rotativa = 1000 : ( tarifa_no_rotativa > 20000 ? tarifa_no_rotativa = 20000 : tarifa_no_rotativa) )

        #Hay 3 escenarios
        #1: monto_final_rotativo = 0 / monto_final_no_rotativo > 0 - Emision no rotativa
        #2: monto_final_rotativo > 0 / monto_final_no_rotativo = 0 - Emision rotativa
        #3: monto_final_rotativo > 0 / monto_final_no_rotativo > 0 - Emision mixta
        #
        #Los condicionales de abajo son necesarios para que puedan ocurrir los 3 escenarios, sin ellos solo ocurriria 1 debido a que las tarifas siempre seran mayor que 0 aun si el monto es 0
        # (monto_final_rotativo = monto_rotativo + tarifa_rotativa) if resolucion_seleccionada["MONTO_ROTATIVO"] > 0
        (monto_final_rotativo = tarifa_rotativa) if resolucion_seleccionada["MONTO_ROTATIVO"] > 0

        # (monto_final_no_rotativo = monto_no_rotativo + tarifa_no_rotativa) if resolucion_seleccionada["MONTO_NO_ROTATIVO"] > 0
        # (monto_final_no_rotativo = tarifa_no_rotativa) if resolucion_seleccionada["MONTO_NO_ROTATIVO"] > 0

        resolucion_seleccionada["MONTO_ROTATIVO_FINAL"] = monto_final_rotativo
        # resolucion_seleccionada["MONTO_NO_ROTATIVO_FINAL"] = monto_final_no_rotativo
        resolucion_seleccionada["MONTO_NO_ROTATIVO_FINAL"] = 0

      end
    end

    return final_output

    #Esta es la informacion que por ahora es o puede ser necesaria

    #Esta es toda la informacion que trae el query
    # cursor.fetch() {|row| output_array.push("ENTE" => "#{row[0]}", "SECTOR" => "#{row[1]}", "RESOLUCION" => "#{row[2]}", "FECHA_RESOLUCION" => "#{row[3]}", "ANIOS" => "#{row[4]}", "TITULO" => "#{row[5]}", "MONTO_EMISION" => "#{row[6]}", "ACCIONES_REGISTRADAS" => "#{row[7]}", "ACCIONES_CIRCULACION" => "#{row[8]}", "SERIE" => "#{row[9]}", "FECHA_OFERTA" => "#{row[10]}", "FECHA_VENCMIENTO_SERIE" => "#{row[11]}", "PERIODO_VENCE" => "#{row[12]}", "MONTO_INICIAL" => "#{row[13]}", "MONTO_CIRCULACION" => "#{row[14]}", "TITULO_VALOR" => "#{row[14]}")}
  end
end
