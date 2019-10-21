class TFacturaPdf < PdfHelper
#Cambiar nombre despues

  require 'prawn/measurement_extensions'
  require 'prawn/table'
  extend Forwardable
  def_delegator :@view, :number_to_currency

  # Constants
  GREEN      = '00B700'
  DARK_GREEN = '00B800'

  # Constructor
  # def initialize(t_factura, t_recibo, view)
  def initialize(t_factura, t_recibo)
    super()
    @t_recibo     = t_recibo
    @t_factura    = t_factura
    @t_resolucion = @t_factura.t_resolucion
    @t_cliente    = @t_resolucion.t_cliente
    @t_empresa    = @t_cliente.persona.try(:rif)            ? @t_cliente.persona : nil
    @t_persona    = @t_cliente.persona.try(:cedula)         ? @t_cliente.persona : nil
    @t_otro       = @t_cliente.persona.try(:identificacion) ? @t_cliente.persona : nil
    # @view = view
    font_size 8
    document_content
  end

  def document_content
    # stroke_axis(step_length: 50)
    page_one
    # pad_top(20) { stroke_horizontal_rule } # 0, bounds.width || 540, at: cursor }
    # move_down(5)
    # pad_top(5) { client }
    # stroke_horizontal_rule
    # invoice_detail
  end

  def logo
    image "#{Rails.root}/app/assets/images/logoSMV.png" , fit: [130,130]
  end

  def header
    fill_color '6D5F83'
    text_box "<b>REPÚBLICA DE PANAMÁ</b>
    <b>SUPERINTENDENCIA DEL MERCADO DE VALORES</b>
    <b>DEPARTAMENTO DE TESORERÍA</b>
    <b>FACTURA</b>", inline_format: true, at: [10,700], align: :center

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

      # text "Recibo: \# #{@t_recibo.id}"
      # text "Estado: #{(@t_recibo.pago_pendiente <= 0) ? 'Pagado' : 'Sin Pagar'}"
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

  def page_one
    logo

    text_box "<b>Fecha de impresión: #{Time.now.strftime('%d/%m/%Y %I:%M:%S %p')}</b>", inline_format: true, at: [380,750]

    text_box "<b>Original Cliente</b>", inline_format: true, at: [490,740]

    fill_color '1A135C'
    text_box "<b>REPÚBLICA DE PANAMÁ</b>
    <b>SUPERINTENDENCIA DEL MERCADO DE VALORES</b>
    <b>DEPARTAMENTO DE TESORERÍA</b>
    <b>FACTURA</b>", inline_format: true, at: [10,700], :align => :center

    stroke do
      move_down 20
      horizontal_rule
    end

    move_down 10

    fill_color '000000'

    bounding_box([0, cursor], :width => 165, :height => 130) do
      # stroke_bounds
      address = @t_cliente.persona_type == "TPersona" ? @t_cliente.persona.direccion : @t_cliente.persona.direccion_empresa
      # debugger
      text_box "<b>Dirección:</b>
      #{address unless address.nil?}
      <b>Apartado Postal:</b> INGRESE EL APARTADO POSTAL
      <b>Teléfono:</b> #{@t_cliente.persona.telefono unless @t_cliente.persona.telefono.nil?}
      <b>Email:</b> #{@t_cliente.persona.email unless @t_cliente.persona.email.nil?}", inline_format: true, at: [5, cursor], :align => :justify
    end

    bounding_box([185, 644], :width => 165, :height => 130) do
      # stroke_bounds
      text_box "<b>Para Cliente:</b> #{@t_cliente.codigo}
      <b>Resolución:</b> #{@t_resolucion.resolucion}
      <b>CIP/RUC:</b> #{@t_persona.try(:cedula) || @t_empresa.try(:rif) || @t_otro.try(:identificacion)}
      <b>Teléfono:</b> INGRESE TELEFONO
      <b>Email:</b> INGRESE CORREO
      ", inline_format: true, at: [5, cursor], :align => :justify
    end

    bounding_box([370, 644], :width => 165, :height => 130) do
      # stroke_bounds
      text_box "<b>Factura:</b>#INGRESE FACTURA
      <b>Estado:</b> INGRESE ESTADO DE FACTURA
      <b>Importe debido:</b> INGRESE IMPORTE debido
      <b>Fecha de vencimiento:</b> INGRESE FECHA DE vencimiento
      <b>Cuenta de venta:</b> INGRESE CUENTA DE venta
      <b>Período:</b> INGRESE PERIODO
      ", inline_format: true, at: [5, cursor], :align => :justify
    end

    big_table_for_5_with_widths_and_alignment_and_height(bold("Cantidad"), bold("Ítem"), bold("Descripción"), bold("Precio"), bold("Importe"), 60, 150, 200, 100, :center, 18)
    #######
    #Loop here plz
    #######

    move_down 30

    bounding_box([0, cursor], :width => 370, :height => 130) do
        # stroke_bounds
        text_box "Mediante la ley 67 de 1 de septiembre de 2011 publicada en la Gaceta Oficial No. 26863-A de 2 de septiembre de 2011, se crea la Superintendencia del Mercado de Valores como un organismo autónomo del Estado, con personería jurídica, patrimonio propio e independencia administrativa, presupuestaria y financiera, con competencia privativa para regular y supervisar a los emisores, sociedades de inversiones, intermediarios y demás participantes del mercados de valores.", inline_format: true, at: [5, cursor], :align => :justify
    end

    move_up 130

    fill_color '000000'

    data = [[bold("Total:"), bold("$ 175,000.00")]]
    table(data, :column_widths => [80, 80],
      :cell_style => {:inline_format => true, :border_width => 0.1, :align => :center,:height => 20}, width: 160, :position => :right )

    fill_color '1A135C'

    text_box "<b>2019 - 20 Años propiciando seguridad, confianza y transparencia</b>", inline_format: true, at: [170,10]
  end
end