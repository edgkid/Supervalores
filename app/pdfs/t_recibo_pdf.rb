class TReciboPdf < Prawn::Document
  require 'prawn/measurement_extensions'
  require 'prawn/table'
  extend Forwardable
  def_delegator :@view, :number_to_currency

  # Constants
  GREEN      = '00B700'
  DARK_GREEN = '00B800'

  # Constructor
  def initialize(t_factura, t_recibo, view)
    super()
    @t_recibo     = t_recibo
    @t_factura    = t_factura
    @t_resolucion = @t_factura.t_resolucion
    @t_cliente    = @t_resolucion.t_cliente
    @t_empresa    = @t_cliente.persona.try(:rif)            ? @t_cliente.persona : nil
    @t_persona    = @t_cliente.persona.try(:cedula)         ? @t_cliente.persona : nil
    @t_otro       = @t_cliente.persona.try(:identificacion) ? @t_cliente.persona : nil
    @view = view
    font_size 8
    document_content
  end

  def document_content
    stroke_axis(step_length: 50)
    logo
    header
    pad_top(20) { stroke_horizontal_rule } # 0, bounds.width || 540, at: cursor }
    # move_down(5)
    pad_top(5) { client }
    # stroke_horizontal_rule
    invoice_detail
  end

  def logo
    image "#{Rails.root}/app/assets/images/logoSMV.png" , fit: [130,130]
  end

  def header
    fill_color '6D5F83'
    text_box "<b>REPÚBLICA DE PANAMÁ</b>
    <b>SUPERINTENDENCIA DEL MERCADO DE VALORES</b>
    <b>DEPARTAMENTO DE TESORERÍA</b>
    <b>RECIBO DE INGRESO</b>", inline_format: true, at: [10,700], align: :center

    text_box "<b>Fecha de impresión: #{Time.now.strftime('%d/%m/%Y %I:%M:%S %p')}</b>", inline_format: true, at: [300,750], align: :right

    text_box "<b>Original Cliente</b>", inline_format: true, at: [480,740]
  end

  def client
    fill_color '000000'
    column_box([0, cursor], columns: 3, width: bounds.width, height: 30) do
      text "Cliente: \# #{@t_cliente.id}"
      text "Nombre: #{@t_persona.try(:nombre) || @t_empresa.try(:razon_social) || @t_otro.try(:razon_social)}"
      text "\n"

      text "Referencia:"
      text "Resolución: #{@t_resolucion.resolucion}"
      text "CIP / RUC: #{@t_persona.try(:cedula) || @t_empresa.try(:rif) || @t_otro.try(:identificacion)}"

      text "Recibo: \##{@t_recibo.id}"
      text "Estado: #{(@t_recibo.pago_pendiente <= 0) ? 'Pagado' : 'Sin Pagar'}"
      text "Fecha: #{@t_factura.created_at.strftime('%d/%m/%Y %I:%M:%S %p')}"
    end
  end

  def invoice_detail
    data = [["Cantidad", "Ítem", "Descripción", "Precio", "Importe", "Saldo"]]

    table(data, cell_style: {borders: [:top, :bottom]}, width: bounds.width)
  end

  def example
    text_box "This is a text box, you can control where it will flow by " +
    "specifying the :height and :width options",
    :at =>[100, 250],
    :height => 100,
    :width => 100

    text_box "Another text box with no :width option passed, so it will " +
    "flow to a new line whenever it reaches the right margin. ",
    :at =>[200, 100]
  end
end