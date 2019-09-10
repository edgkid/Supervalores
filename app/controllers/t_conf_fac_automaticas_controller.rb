class TConfFacAutomaticasController < ApplicationController
  before_action :set_t_factura, only: :show

  def new
    # @do_not_use_plain_select2 = true
    @no_cache = true
    @t_conf_fac_automatica = TConfFacAutomatica.new
  end

  def create
    @t_conf_fac_automatica = TConfFacAutomatica.new(t_factura_params)

    if @t_conf_fac_automatica.save
      redirect_to t_conf_fac_automaticas_path, notice: 'Configuración de Factura creada exitosamente'
    else
      @notice = @t_conf_fac_automatica.errors
      render 'new'
    end
  end

  def index
    @usar_dataTables = true
    @t_conf_fac_automaticas = TConfFacAutomatica.all
    j = 0
    # jobs = []
    scheduler = Rufus::Scheduler.singleton

    TConfFacAutomatica.all.each_with_index do |configuracion, i|
      justificacion = configuracion.nombre_ciclo_facturacion
      t_estatus = TEstatus.first
      t_recargos = configuracion.t_recargos
      t_periodo = configuracion.t_periodo
      t_resolucion = configuracion.t_tipo_cliente.t_resolucion
      t_tarifa_servicios = configuracion.t_tarifa_servicios
      t_tarifas = configuracion.t_tarifas

      # scheduler.at "#{configuracion.fecha_inicio} 0000" do
      scheduler.in '10m' do
        # scheduler.schedule_every '1month' do |job|
        scheduler.schedule_every '4h' do |job|
          if j > 2
            job.unschedule if job.scheduled?
            job.kill if job.running?
          end
          t_clientes = TCliente.joins("
            INNER JOIN t_resolucions
            ON t_resolucions.t_cliente_id = t_clientes.id
            AND t_resolucions.t_tipo_cliente_id = #{configuracion.t_tipo_cliente_id}",
          ).distinct

          t_clientes.each do |t_cliente|
            t_factura = TFactura.new(
              fecha_notificacion: Date.today,
              fecha_vencimiento: Date.today + 1.month,
              recargo: 0,
              recargo_desc: '-',
              itbms: 0,
              importe_total: 0,
              pendiente_fact: 0,
              pendiente_ts: 0,
              tipo: '-',
              next_fecha_recargo: Date.today + 1.month,
              monto_emision: 0,
              justificacion: justificacion,
              automatica: true,
              t_estatus: t_estatus,
              t_periodo: t_periodo,
              # t_tarifa_servicios: configuracion.t_tarifa_servicios,
              t_recargos: t_recargos,
              t_resolucion: t_resolucion,
              # t_tarifas: configuracion.t_tarifas,
              user: User.first
            )

            t_factura.calculate_total(
              t_tarifa_servicios.sum(:precio),
              t_recargos.map { |r| r.tasa },
              t_tarifas.map { |t| t.calculate_total }
            )

            if t_factura.save
              puts "\n" * 5 + 'Facturas automáticas creadas!'
            else
              puts "\n" * 5 + 'Al menos una factura no se pudo crear'
            end

            j += 1
          end

          # ESTE ES EL MISMO CÓDIGO DE ARRIBA, PERO SIN NEW LINES PARA PROBAR MÁS
          # CÓMODAMENTE EN LA CONSOLA
          # TConfFacAutomatica.all.each_with_index do |configuracion, i|
          #   t_clientes = TCliente.joins("INNER JOIN t_resolucions ON t_resolucions.t_cliente_id = t_clientes.id AND t_resolucions.t_tipo_cliente_id = #{configuracion.t_tipo_cliente_id}").distinct

          #   t_clientes.each do |t_cliente|
          #     t_factura = TFactura.new(fecha_notificacion: Date.today, fecha_vencimiento: Date.today + 1.month, recargo: 0, recargo_desc: '-', itbms: 0, importe_total: 0, pendiente_fact: 0, pendiente_ts: 0, tipo: '-', next_fecha_recargo: Date.today + 1.month, monto_emision: 0, justificacion: configuracion.nombre_ciclo_facturacion, automatica: true, t_estatus: TEstatus.first, t_periodo: configuracion.t_periodo, t_recargos: configuracion.t_recargos, t_resolucion: configuracion.t_tipo_cliente.t_resolucion, user: User.first)
          #     t_factura.calculate_total(configuracion.t_tarifa_servicios.sum(:precio), configuracion.t_recargos.map { |r| r.tasa }, configuracion.t_tarifas.map { |t| t.calculate_total })

          #     if t_factura.save
          #       puts "\n" * 5 + 'Facturas automáticas creadas!'
          #     else
          #       puts "\n" * 5 + 'Al menos una factura no se pudo crear'
          #     end
          #   end
          # end
          # AQUÍ TERMINA EL CÓDIGO DE PRUEBA

          # puts configuracion.nombre_ciclo_facturacion
          # j += 1
          # if j > 2

            # job.unschedule if job.scheduled?
            # job.kill if job.running?

            # puts "Job corriendo? #{job.running?}"

            # jobs.each do |job|
            #   job.unschedule if job.scheduled?
            #   job.kill if job.running?
            # end
          # end
        end

        # jobs << job
      end

      # puts "scheduled job #{job_id}"
    end

    # scheduler.every '3s' do
    #   puts "Jobs corriendo: #{scheduler.running_jobs}"
    #   puts "Cantidad de jobs: #{scheduler.running_jobs.count}"
    #   scheduler.shutdown
    # end
  end

  def show
    @t_tarifa_servicios = @t_conf_fac_automatica.t_tarifa_servicios
    @t_recargos = @t_conf_fac_automatica.t_recargos
    @t_tarifas = @t_conf_fac_automatica.t_tarifas
  end

  def destroy
    @t_conf_fac_automatica = TConfFacAutomatica.find(params[:id])
    @t_conf_fac_automatica.destroy

    redirect_to t_conf_fac_automaticas_path, notice: 'Configuración de Factura eliminada exitosamente'
  end

  private

    def t_factura_params
      params.require(:t_conf_fac_automatica).permit(
        :nombre_ciclo_facturacion, :fecha_inicio, :t_tipo_cliente_id, :t_periodo_id,
        {t_tarifa_servicio_ids: []}, {t_recargo_ids: []}, {t_tarifa_ids: []}
      )
    end

    def set_t_factura
      @t_conf_fac_automatica = TConfFacAutomatica.find(params[:id])
    end
end
