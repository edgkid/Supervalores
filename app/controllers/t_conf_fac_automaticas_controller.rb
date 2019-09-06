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
      redirect_to t_conf_fac_automaticas_path
    else
      @notice = @t_conf_fac_automatica.errors
      render 'new'
    end
  end

  def index
    @usar_dataTables = true
    @t_conf_fac_automaticas = TConfFacAutomatica.all
    # job_id =
    #   Rufus::Scheduler.singleton.in '10s' do
    #     Rails.logger.info "time flies, it's now #{Time.now}"
    #   end
    # j = 0
    # jobs = []
    scheduler = Rufus::Scheduler.singleton

    TConfFacAutomatica.all.each_with_index do |configuracion, i|
      # scheduler.at "#{configuracion.fecha_inicio} 0000" do
      scheduler.in '2s' do
        # scheduler.every 
        scheduler.schedule_every '1month' do |job|
          t_tipo_cliente = configuracion.t_tipo_cliente
          t_periodo = configuracion.t_periodo
          # puts configuracion.nombre_ciclo_facturacion
          # j += 1
          # if j > 2
            # puts "Job 1 corriendo? #{jobs[0].running?}"
            # puts "Job 2 corriendo? #{jobs[1].running?}"
            # puts "Job corriendo? #{job.running?}"

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
