class TRecargo < ApplicationRecord
  # belongs_to :t_factura, optional: true
	belongs_to :t_periodo
	
	#has_many :t_recargo_x_cliente
	#has_many :t_cliente, through: :t_recargo_x_cliente
	has_many :t_recargo_x_clientes, dependent: :destroy
	has_many :t_resolucions, through: :t_recargo_x_cliente
  has_many :t_recargo_facturas, dependent: :destroy
  has_many :t_facturas, through: :t_recargo_facturas

  def schedule_surcharges(t_factura, estatus)
    scheduler = Rufus::Scheduler.singleton

    if estatus == 1
      # scheduler.schedule_every "#{self.t_periodo.rango_dias}d" do |job|
      scheduler.schedule_every '1month' do |job|
        generate_surcharge(job, t_factura, estatus)
      end
    end
  end

  def generate_surcharge(job, t_factura, estatus)
    recargo_actual = TRecargo.find(self.id)

    if recargo_actual.estatus != 1
      puts 'Terminating jobs!'
      job.unschedule if job.scheduled?
      job.kill if job.running?
    else
      puts 'Job is up yet!'
      puts "Job id: #{job.id}"
    end

    # Lógica para agregar recargo aquí.
  end
end
