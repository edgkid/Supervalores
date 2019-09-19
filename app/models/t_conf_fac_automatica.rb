class TConfFacAutomatica < ApplicationRecord
  belongs_to :t_tipo_cliente
  belongs_to :t_periodo

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

  def schedule_invoices(current_user)
    scheduler = Rufus::Scheduler.singleton

    if self.estatus == 1
      # scheduler.at "#{configuracion.fecha_inicio} 0000" do
      scheduler.in '2s' do
        # scheduler.schedule_every '1month' do |job|
        $job = scheduler.schedule_every '5s' do |job|
          if TConfFacAutomatica.find(self.id).estatus != 1
            puts 'Terminating jobs!'
            job.unschedule if job.scheduled?
            job.kill if job.running?
          else
            puts 'Job is up yet!'
            puts "Job id: #{job.id}"
          end

          t_clientes = TCliente.joins("
            INNER JOIN t_resolucions
            ON t_resolucions.t_cliente_id = t_clientes.id
            AND t_resolucions.t_tipo_cliente_id = #{self.t_tipo_cliente_id}",
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
              justificacion: self.nombre_ciclo_facturacion,
              automatica: true,
              t_estatus: TEstatus.first,
              t_periodo: self.t_periodo,
              t_recargos: self.t_recargos,
              t_resolucion: self.t_tipo_cliente.t_resolucion,
              user: current_user
            )

            t_factura.calculate_total(
              self.t_tarifa_servicios.sum(:precio),
              self.t_recargos.map { |r| r.tasa },
              self.t_tarifas.map { |t| t.calculate_total }
            )

            if t_factura.save
              puts "\n" * 5 + '¡Facturas automáticas creadas!'
            else
              puts "\n" * 5 + '¡La factura no se pudo crear!'
            end
          end
        end
      end
    end
  end
end
