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
    return "fac_auto_#{self.id}"
  end

  def schedule_invoices
    scheduler = Rufus::Scheduler.singleton

    if self.estatus == 1
      # scheduler.at "#{configuracion.fecha_inicio} 0000" do
      scheduler.in '2s' do |j0b|
        create_invoices(j0b)
        # scheduler.schedule_every '1month' do |job|
        # scheduler.schedule_every '5m', :tags => self.job_tag do |job|
        #   create_invoices(job)
        # end
      end
    end
  end

  def create_invoices(job)
    configuracion_actual = TConfFacAutomatica.find(self.id)

    if configuracion_actual.estatus != 1
      puts 'Terminating jobs!'
      job.unschedule if job.scheduled?
      job.kill if job.running?
    else
      puts 'Job is up yet!'
      puts "Job id: #{job.id}"
    end

    # t_clientes = TCliente.joins("
    #   INNER JOIN t_resolucions
    #   ON t_resolucions.t_cliente_id = t_clientes.id
    #   AND t_resolucions.t_tipo_cliente_id = #{configuracion_actual.t_tipo_cliente_id}",
    # ).distinct

    t_resolucions = TResolucion.where(t_tipo_cliente: configuracion_actual.t_tipo_cliente)

    #t_clientes.each do |t_cliente|
    t_resolucions.each do |t_resolucion|
      t_factura = TFactura.new(
        fecha_notificacion: Date.today,
        fecha_vencimiento: Date.today + 1.month,
        recargo_desc: '-',
        itbms: 0,
        importe_total: 0,
        pendiente_ts: 0,
        tipo: '-',
        next_fecha_recargo: Date.today + 1.month,
        monto_emision: 0,
        justificacion: configuracion_actual.nombre_ciclo_facturacion,
        automatica: true,
        t_estatus: TEstatus.find_by(descripcion: 'Disponible') || TEstatus.first.id,
        t_periodo: configuracion_actual.t_periodo,
        t_recargos: configuracion_actual.t_recargos,
        t_resolucion: t_resolucion,
        user: configuracion_actual.user
      )

      configuracion_actual.t_tarifa_servicios.each do |t_tarifa_servicio|
        t_factura.t_factura_detalles.build(
          cantidad: 1,
          cuenta_desc: t_tarifa_servicio.descripcion,
          precio_unitario: t_tarifa_servicio.precio,
          t_factura: t_factura,
          t_tarifa_servicio: t_tarifa_servicio
        )
      end

      t_factura.recargo = t_factura.calculate_total_surcharge(true)
      t_factura.pendiente_fact = t_factura.calculate_pending_payment(true)
      t_factura.total_factura = t_factura.calculate_total(true)

      if t_factura.save!
        puts "\n" * 5 + '¡Facturas automáticas creadas!' + "\n"

        # active = (t_factura.calculate_pending_payment <= 0) ? true : false

        t_factura.t_recargos.each do |t_recargo|
          t_recargo.schedule_surcharges(t_factura, configuracion_actual.estatus)
        end
      else
        puts "\n" * 5 + '¡La factura no se pudo crear!'
      end
    end
    
    puts self.job_tag + " -> " + self.updated_at.strftime("%s") #+ " -- " + jobs.inspect()
  end
end
