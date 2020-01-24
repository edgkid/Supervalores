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
  has_many :t_recargo_facturas, dependent: :destroy
  accepts_nested_attributes_for :t_recargo_facturas, allow_destroy: true
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

  def calculate_total_surcharge_rate
    sum = 0
    self.t_recargo_facturas.each do |t_recargo_factura|
      sum += t_recargo_factura.cantidad * t_recargo_factura.precio_unitario
    end
    sum
  end

  def calculate_total_surcharge
    calculate_total_surcharge_rate * calculate_services_total_price
  end

  def calculate_total
    calculate_services_total_price + calculate_total_surcharge
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

  def generate_surcharge(price_rate, job)
    t_factura_actual = find_self

    estatus_fac = t_factura_actual.t_estatus.descripcion
    if estatus_fac.downcase != 'facturada' && estatus_fac.downcase != 'pago pendiente'
      terminate_job(job)
    else
      puts 'Job is up yet!'
      puts "Job id: #{job.id}"
    end

    t_recibos = t_factura_actual.t_recibos
    old_t_factura = t_factura_actual.dup

    if t_recibos.any? && t_recibos.find_by(ultimo_recibo: true).pago_pendiente <= 0
      terminate_job(job)
    end

    t_factura_actual.t_recargo_facturas.build(
      cantidad: 1,
      precio_unitario: price_rate[1],
      monto: price_rate[0],
      t_recargo: TRecargo.where(
        descripcion: "Recargo automático del #{price_rate[1] * 100}\%",
        tasa: price_rate[1],
        estatus: 1,
        t_periodo: TPeriodo.where(
          descripcion: 'Periodo Mensual',
          tipo: 'Mensual',
          dia_tope: (Date.today + 1.month).at_end_of_month.day,
          mes_tope: (Date.today + 1.month).month,
          rango_dias: 30,
          estatus: 1
        ).first_or_create!
      ).first_or_create!
    )

    # debugger

    update_surcharges(price_rate[0], t_factura_actual)
  end

  def schedule_surcharge(t_recargo)
    scheduler = Rufus::Scheduler.singleton(:max_work_threads => 5)

    estatus_fac = self.t_estatus.descripcion
    if estatus_fac.downcase == 'facturada' || estatus_fac.downcase == 'pago pendiente'
      scheduler.at "#{self.fecha_vencimiento + 1.day} 0000" do |job1|
      # scheduler.in '5s' do |job1|

        t_recargo_actual = TRecargo.find(t_recargo.id)

        generate_surcharge(t_recargo_actual.tasa, job1)

        period_type = TPeriodo.translate_period_type_to_cron(t_recargo_actual.t_periodo.tipo)
        scheduler.schedule_every "#{period_type}" do |job2|
        # scheduler.schedule_every '25s' do |job2|
          generate_surcharge(t_recargo.tasa, job2)
        end
      end
    end
  end

  def schedule_custom_percent_monthly_surcharge
    # debugger
    scheduler = Rufus::Scheduler.singleton

    if self.t_estatus.descripcion.downcase == 'facturada' || self.t_estatus.descripcion.downcase == 'pago pendiente'
      # El primer recargo se aplicará un día después de la fecha de vencimiento a las 00:00.
      # scheduler.at "#{self.fecha_vencimiento + 1.day} 0000" do |j0b|
      scheduler.in "3s" do |job1|
        find_invoice_and_generate_surcharge(TConfiguracionRecargoT.take.try(:tasa) || 0, job1)

        t_factura = find_self
        # El siguiente recargo se hará dependiendo de si fue en enero o no.
        months_to_wait = is_January? ? 2 : 1
        # Si fue en enero, entonces el siguiente recargo se hará el primer día de marzo, si no,
        # el primer día del siguiente mes.
        scheduler.at "#{(t_factura.fecha_vencimiento + months_to_wait.month).at_beginning_of_month} 0000" do |job2|
          # Los siguientes recargos se harán cada mes
          scheduler.schedule_every '1month' do |job3|
          # scheduler.schedule_every '20s' do |job3|
            find_invoice_and_generate_surcharge(TConfiguracionRecargoT.take.try(:tasa) || 0, job3)
          end
        end
      end
    end
  end

  def is_January?
    find_self.fecha_vencimiento.month == 1
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

  def monto_pendiente_para_pdf
    monto_pendiente = 0 
    self.t_recibos.order("created_at ASC").first(self.t_recibos.count - 1).each do |recibo|
      monto_pendiente += recibo.pago_recibido
    end
    monto_final = self.calcular_total_factura - monto_pendiente
    monto_final < 0 ? 0 : monto_final
  end

  def update_receipts(old_t_factura)
    t_recibos = self.t_recibos

    if (ultimo_recibo = t_recibos.find_by(ultimo_recibo: true))
      t_recibos.each do |t_recibo|
        t_recibo.pago_pendiente +=
          (self.pendiente_fact - ultimo_recibo.pago_pendiente)
        t_recibo.save
      end
      
      ultimo_recibo.recargo_x_pagar = (ultimo_recibo.recargo_x_pagar || 0)
        self.recargo - old_t_factura.recargo
      ultimo_recibo.servicios_x_pagar = (ultimo_recibo.servicios_x_pagar || 0)
        ((self.total_factura - self.recargo) -
        (old_t_factura.total_factura - old_t_factura.recargo))
      ultimo_recibo.save
    end
  end

  def update_surcharges(surcharge_price, t_factura_actual = self)
    t_recibos = t_factura_actual.t_recibos

    if (ultimo_recibo = t_recibos.find_by(ultimo_recibo: true))
      t_recibos.each do |t_recibo|
        t_recibo.recargo_x_pagar += surcharge_price
        t_recibo.pago_pendiente += surcharge_price
        t_recibo.save
      end
    else
      # t_factura_actual.recargo += surcharge_price
      # t_factura_actual.total_factura += surcharge_price
      # t_factura_actual.pendiente_fact += surcharge_price
    end
    t_factura_actual.recargo += surcharge_price
    t_factura_actual.total_factura += surcharge_price
    t_factura_actual.pendiente_fact += surcharge_price

    t_factura_actual.save
  end

  def update_deleted_surcharge(rate)
    t_recibos = self.t_recibos

    if (ultimo_recibo = t_recibos.find_by(ultimo_recibo: true))
      new_surcharge_price = ultimo_recibo.servicios_x_pagar * rate
      t_recibos.each do |t_recibo|
        t_recibo.recargo_x_pagar -= new_surcharge_price
        t_recibo.pago_pendiente -= new_surcharge_price
        t_recibo.save
      end
    else
      new_surcharge_price = self.calculate_services_total_price * rate
      self.recargo -= new_surcharge_price
      self.total_factura -= new_surcharge_price
      self.pendiente_fact -= new_surcharge_price
    end

    self.save
  end

  def puede_tener_mas_recargos?
    if (ultimo_recibo = self.t_recibos.find_by(ultimo_recibo: true))
      ultimo_recibo.recargo_x_pagar < ultimo_recibo.servicios_x_pagar ? true : false
    else
      self.calculate_total_surcharge < self.calculate_services_total_price ? true : false
    end
  end

  def corregir_tasa_de_recargo(tasa)
    # Se obtiene la diferencia entre el total de los servicios menos los recargos
    diferencia =
      if (ultimo_recibo = self.t_recibos.find_by(ultimo_recibo: true))
        (total_servicios = ultimo_recibo.servicios_x_pagar) - ultimo_recibo.recargo_x_pagar
      else
        (total_servicios = self.calculate_services_total_price) - self.calculate_total_surcharge
      end
    # Si el recargo (tasa * el total se los servicios) es mayor que la diferencia,
    # entonces se retornará la tasa de la diferencia (ya que el recargo total no puede ser mayor que
    # el total de los servicios)
    nuevo_precio = tasa * total_servicios > diferencia ? diferencia : tasa * total_servicios,
    tasa * total_servicios > diferencia ? (diferencia / total_servicios) : tasa
  end

  def calcular_saldo_pendiente
    #Calcula el saldo pendiente, tomando en consideracion los t_factura_detalles junto a los t_recargo_facturas y los recibos asociados
    self.t_factura_detalles.sum(:precio_unitario) + (self.t_factura_detalles.sum(:precio_unitario) * self.t_recargo_facturas.sum(:precio_unitario)) - self.t_recibos.sum(:pago_recibido)
  end

  def calcular_total_factura
    self.t_factura_detalles.sum(:precio_unitario) + (self.t_factura_detalles.sum(:precio_unitario) * self.t_recargo_facturas.sum(:precio_unitario))
  end

  private

    def find_invoice_and_generate_surcharge(rate, job)
      t_factura = find_self
      estatus_fac = t_factura.t_estatus.descripcion
      if estatus_fac.downcase == 'facturada' || estatus_fac.downcase == 'pago pendiente'
        t_recibos = t_factura.t_recibos
        unless t_recibos.any? && t_recibos.find_by(ultimo_recibo: true).pago_pendiente <= 0
          generate_surcharge(t_factura.corregir_tasa_de_recargo(rate), job) if t_factura.puede_tener_mas_recargos?
          puts "Recargo del #{rate * 100}\% generado!"
        else
          terminate_job(job)
        end 
      else
        terminate_job(job)
      end
    end

    def terminate_job(job)
      puts "Terminating jobs!"
      job.unschedule if job.scheduled?
      job.kill if job.running?
    end

    def find_self
      TFactura.find(self.id)
    end
end
