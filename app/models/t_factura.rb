# == Schema Information
#
# Table name: t_facturas
#
#  id                 :bigint           not null, primary key
#  fecha_notificacion :date             not null
#  fecha_vencimiento  :date             not null
#  recargo            :float            not null
#  recargo_desc       :string           not null
#  itbms              :float            not null
#  cantidad_total     :integer
#  importe_total      :float            not null
#  total_factura      :float            not null
#  pendiente_fact     :float            not null
#  pendiente_ts       :float            not null
#  tipo               :string           not null
#  justificacion      :string
#  fecha_erroneo      :datetime
#  next_fecha_recargo :date             not null
#  monto_emision      :float            not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  t_resolucion_id    :bigint
#  t_periodo_id       :bigint
#  t_estatus_id       :bigint           not null
#  t_leyenda_id       :bigint
#  user_id            :bigint           not null
#  automatica         :boolean          default(FALSE)
#  t_cliente_id       :bigint
#

class TFactura < ApplicationRecord
	belongs_to :t_cliente, optional: true
  belongs_to :t_resolucion, optional: true
  belongs_to :t_periodo, optional: true
  belongs_to :t_estatus
  # belongs_to :t_estatus_fac
  belongs_to :t_leyenda, optional: true
  belongs_to :user

  has_many :t_factura_detalles, dependent: :destroy
  accepts_nested_attributes_for :t_factura_detalles, allow_destroy: true
  has_many :t_recibos, dependent: :destroy
  has_many :t_email_masivos, dependent: :destroy
  has_many :t_nota_creditos, dependent: :destroy
  has_many :t_estado_cuentums, dependent: :destroy
  has_many :t_clientes, through: :t_estado_cuentum
  has_many :t_recargo_facturas, dependent: :destroy
  has_many :t_recargos, through: :t_recargo_facturas

  validates :fecha_notificacion, presence: {
    message: "|La fecha de notificación no puede estar vacía"
  }
  validates :fecha_vencimiento, presence: {
    message: "|La fecha de vencimiento no puede estar vacía"
  }
  # validates :t_resolucion, presence: {
  #   message: "|La resolución debe existir"
  # }

  def set_recargo
    total = 0
    self.t_recargos.each { |r| total += r.tasa }
    total * 100
  end

  def calculate_pending_payment(before_save = false)
    if before_save
      sum = 0
      self.t_recibos.each { |t_recibo| sum += t_recibo.pago_recibido }
      (self.calculate_services_total_price + self.recargo || 0) - sum
    else
      (self.calculate_services_total_price + self.recargo || 0) - self.t_recibos.sum(:pago_recibido)
    end
  end

  def calculate_services_total_price
    sum = 0
    self.t_factura_detalles.each { |t_factura_detalle| sum += t_factura_detalle.precio_unitario * t_factura_detalle.cantidad }
    sum
  end

  def calculate_total_surcharge_rate(before_save = false)
    if before_save
      sum = 0
      self.t_recargos.each { |t_recargo| sum += t_recargo.tasa }
      sum
    else
      self.t_recargos.sum(:tasa)
    end
  end

  def calculate_total_surcharge(before_save = false)
    if before_save
      calculate_total_surcharge_rate(true) * calculate_services_total_price
    else
      calculate_total_surcharge_rate * calculate_services_total_price
    end
  end

  def calculate_total(before_save = false)
    if before_save
      calculate_services_total_price + calculate_total_surcharge(true)
    else
      calculate_services_total_price + calculate_total_surcharge
    end
  end

  def self.count_invoices_by_month(month_number)
    TFactura.where('extract(month  from created_at) = ?', month_number).count
  end

  def self.count_invoices_by_months(number_of_months)
    older_month = (Date.today - number_of_months.months).month
    invoices_list = []

    (older_month..Date.today.month).each do |month_number|
      invoices_list << TFactura.count_invoices_by_month(month_number)
    end

    invoices_list
  end

  def get_next_surcharge_date(due_date)
    self.t_recargos.each_with_index do |t_recargo, i|
      next_surcharge_date = (due_date + 1.day) if i == 0
      next_surcharge_date = (due_date + t_recargo.t_periodo.rango_dias.days) if next_surcharge_date >
                            (due_date + t_recargo.t_periodo.rango_dias.days)
    end
    next_surcharge_date
  end

  def generate_surcharge(rate, job)
    t_factura_actual = TFactura.find(self.id)
    if t_factura_actual.t_estatus.descripcion != 'Disponible'
      puts 'Terminating surcharge job!'
      job.unschedule if job.scheduled?
      job.kill if job.running?
    else
      puts 'Job is up yet!'
      puts "Job id: #{job.id}"
    end

    t_recibos = t_factura_actual.t_recibos

    if t_recibos.any?
      t_recibo = t_recibos.last
      surcharge_to_apply = t_recibo.servicios_x_pagar * rate
      total_surcharge = t_recibo.recargo_x_pagar + surcharge_to_apply

      if total_surcharge < t_recibo.servicios_x_pagar
        t_recibo.recargo_x_pagar = total_surcharge.truncate(2)
        t_recibo.pago_pendiente += surcharge_to_apply.truncate(2)
      else
        t_recibo.recargo_x_pagar = t_recibo.servicios_x_pagar
        t_recibo.pago_pendiente = t_recibo.servicios_x_pagar * 2
      end

      t_recibo.save!
      puts 'Recibo actualizado con el nuevo recargo!'
      puts "self.recargo: #{t_recibo.recargo_x_pagar}"

      if t_recibo.pago_pendiente <= 0
        puts 'Terminating surcharge job!'
        job.unschedule if job.scheduled?
        job.kill if job.running?
      end
    else
      services_total_price = t_factura_actual.calculate_services_total_price
      surcharge_to_apply = services_total_price * rate
      total_surcharge = t_factura_actual.recargo + surcharge_to_apply

      if total_surcharge < services_total_price
        t_factura_actual.recargo = total_surcharge.truncate(2)
        t_factura_actual.total_factura = services_total_price + t_factura_actual.recargo
      else
        t_factura_actual.recargo = services_total_price
        t_factura_actual.total_factura = services_total_price * 2
      end

      t_factura_actual.save!
      puts 'Factura actualizada con el nuevo recargo!'
      puts "self.recargo: #{t_factura_actual.recargo}"
      puts "total_surcharge: #{total_surcharge}"
    end
  end

  def schedule_surcharge(t_recargo)
    scheduler = Rufus::Scheduler.singleton

    if self.t_estatus.descripcion == 'Disponible'
      scheduler.at "#{self.fecha_vencimiento + 1.day} 0000" do
      # scheduler.in '10s' do |j0b|
        t_recargo_actual = TRecargo.find(t_recargo.id)

        generate_surcharge(t_recargo_actual.tasa, j0b)

        period_type = TPeriodo.translate_period_type_to_cron(t_recargo_actual.t_periodo.tipo)
        scheduler.schedule_every "#{period_type}" do |job|
        # scheduler.schedule_every '25s' do |job|
          generate_surcharge(t_recargo.tasa, job)
        end
      end
    end
  end

  def apply_2_percent_monthly_surcharge
    scheduler = Rufus::Scheduler.singleton

    if self.t_estatus.descripcion.downcase == 'disponible'
      scheduler.at "#{self.fecha_vencimiento + 1.day} 0000" do |j0b|
        terminate = false
        t_factura = TFactura.find(self.id)
        if t_factura.t_estatus.descripcion.downcase == 'disponible'
          t_recibos = t_factura.t_recibos
          unless t_recibos.any? && t_recibos.last.pago_pendiente <= 0
            generate_surcharge(0.02, j0b)
            puts "Recargo del 2\% generado!"
          else
            terminate = true
          end 
        else
          terminate = true
        end

        if terminate
          puts "Terminating 2\% surcharge jobs!"
          j0b.unschedule if j0b.scheduled?
          j0b.kill if j0b.running?
        end

        scheduler.schedule_every '1month' do |job|
        # scheduler.schedule_every '20s' do |job|
          terminate = false
          t_factura = TFactura.find(self.id)
          if t_factura.t_estatus.descripcion.downcase == 'disponible'
            t_recibos = t_factura.t_recibos
            unless t_recibos.any? && t_recibos.last.pago_pendiente <= 0
              generate_surcharge(0.02, job)
              puts "Recargo del 2\% generado!"
            else
              terminate = true
            end 
          else
            terminate = true
          end

          if terminate
            puts "Terminating 2\% surcharge jobs!"
            job.unschedule if job.scheduled?
            job.kill if job.running?
          end
        end
      end
    end
  end

  def calculate_credit_balance
    credit = 0
    facturas = self.t_resolucion.t_facturas
    facturas.each do |factura|
      credit = credit + (factura.total_factura - factura.t_recibos.sum(:pago_recibido))
    end
    credit.abs
  end

  def pendiente_total
    total_recibos = self.t_recibos.sum(:pago_recibido) - self.t_recibos.sum(:monto_acreditado)
    total_nota_credito = self.t_nota_creditos.last.nil? ? 0 : self.t_nota_creditos.last.monto
    self.total_factura - (total_recibos + total_nota_credito)
  end

  def es_ts?
    tarifas = TTarifaServicio.where("nombre ilike '%TS%'").pluck(:nombre)
    self.t_factura_detalles.each do |fdet|
      return true if tarifas.include?(fdet.t_tarifa_servicio.nombre)
    end
    return false
  end
end
