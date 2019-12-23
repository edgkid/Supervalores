class TReciboPdf < PdfHelper
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
  def initialize(t_factura, t_recibo, user_id)
    super()
    @current_user = User.find(user_id)
    @t_recibo     = t_recibo
    @t_factura    = t_factura
    @t_resolucion = @t_factura.t_resolucion
    @t_cliente    = @t_resolucion.try(:t_cliente) || @t_factura.try(:t_cliente)
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
    page_two
    page_three
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

    fill_color '1A135C'

    text_box "<b>Fecha de impresión: #{Time.now.strftime('%d/%m/%Y %I:%M:%S %p')}</b>", inline_format: true, at: [380,750]

    text_box "<b>Original Cliente</b>", inline_format: true, at: [490,740]

    text_box "<b>REPÚBLICA DE PANAMÁ</b>
    <b>SUPERINTENDENCIA DEL MERCADO DE VALORES</b>
    <b>DEPARTAMENTO DE TESORERÍA</b>", inline_format: true, at: [10,700], :align => :center

    text_box "<b>RECIBO DE INGRESO</b>", inline_format: true, at: [10,665], :align => :center

    stroke do
      move_down 20
      horizontal_rule
    end

    move_down 10

    fill_color '000000'
  

    bounding_box([0, cursor], :width => 165, :height => 40) do
      # stroke_bounds
    
      poly_name = "#{@t_persona.try(:nombre)} #{@t_persona.try(:apellido)} #{@t_empresa.try(:razon_social)}"

      text_box "<b>Cliente:</b> #{@t_cliente.codigo}
      <b>Nombre:</b> #{poly_name.strip!}
      ", inline_format: true, at: [5, cursor], :align => :justify
    end

    bounding_box([185, 644], :width => 165, :height => 40) do
      # stroke_bounds
      text_box "<b>Referencia:</b>
      <b>CIP/RUC:</b> #{@t_empresa.try(:rif)}#{@t_persona.try(:cedula)}
      <b>Resolucion:</b> #{@t_recibo.t_resolucion.nil? ? "No posee resolucion" : @t_recibo.t_resolucion.resolucion}
      ", inline_format: true, at: [5, cursor], :align => :justify

    end
    

    bounding_box([370, 644], :width => 165, :height => 40) do
      # stroke_bounds
      text_box "<b>Número Recibo:</b> #{@t_recibo.id}
      <b>Número Factura:</b> #{@t_factura.id}
      <b>Estado:</b> #{(@t_recibo.pago_pendiente <= 0) ? 'Pagado' : 'Sin Pagar'}
      <b>Fecha:</b> #{@t_recibo.created_at.strftime('%d/%m/%Y %I:%M:%S %p')}
      ", inline_format: true, at: [5, cursor], :align => :justify
    end


    big_table_for_5_with_widths_and_alignment(
      bold("Cantidad"), 
      bold("Ítem"), 
      bold("Descripción"), 
      bold("Precio"), 
      bold("Saldo"),
      45, 130, 240, 70, :center)

    @t_factura.t_factura_detalles.each do |fd|
      big_table_for_5_with_widths_and_alignment(
        "#{fd.cantidad}", 
        "#{fd.t_tarifa_servicio.nombre}", 
        "#{fd.cuenta_desc}", 
        "#{fd.precio_unitario}", 
        "#{fd.precio_unitario * fd.cantidad}", 
        45, 130, 240, 70, :center)
    end

    @t_factura.t_recargos.each do |r|
      big_table_for_5_with_widths_and_alignment(
        "", 
        "Recargo", 
        "#{r.descripcion}", 
        "#{r.tasa * @t_factura.calculate_services_total_price}", 
        "",
        45, 130, 240, 70, :center)
    end  

    move_down 30

    bounding_box([0, cursor], :width => 270, :height => 110) do
        num_cheque = @t_recibo.t_metodo_pago.forma_pago == "Cheque" ? "<b>N° de cheque:</b> #{@t_recibo.num_cheque}" : ""
        # stroke_bounds
        text_box "<b>Método de Pago:</b> #{@t_recibo.t_metodo_pago.forma_pago}
        #{num_cheque}", inline_format: true, at: [5, cursor], :align => :justify
    end

    move_up 110

    table_for_2_with_widths_and_height_and_alignment_to_the_right(
      bold("Total Factura:"),
      bold("#{@t_factura.total_factura}"),
      110, 110, 20, :center)

    if @t_recibo.t_nota_creditos.count == 0
      monto_pendiente = @t_factura.pendiente_total + @t_recibo.pago_recibido
    else
      monto_pendiente = @t_recibo.t_nota_creditos.sum(:monto) + @t_recibo.pago_recibido
    end

    table_for_2_with_widths_and_height_and_alignment_to_the_right(
      bold("Pendiente Factura:"),
      bold("#{@t_factura.monto_pendiente_para_pdf}"),
      110, 110, 20, :center)

    table_for_2_with_widths_and_height_and_alignment_to_the_right(
      bold("Pago Recibido:"),
      bold("#{@t_recibo.pago_recibido}"),
      110, 110, 20, :center)

    table_for_2_with_widths_and_height_and_alignment_to_the_right(
      bold("Saldo Pendiente:"),
      bold("#{@t_factura.pendiente_total.round(2)}"),
      110, 110, 20, :center)

    stroke do
      move_down 10
      horizontal_rule
    end

    move_down 20

    bounding_box([0, cursor], :width => bounds.width, :height => 70) do
        # stroke_bounds
        text_box "<b>Cajero(a):</b> #{@current_user.nombre} #{@current_user.apellido}                                                                                                                                 
        
        <b>IMPORTANTE:</b> Verifique que el nombre en el presente recibo haya sido escrito de la forma correcta. En caso de una devolución, la misma se realizará a nombre de quien aparece en este recibo de pago.", inline_format: true, at: [5, cursor], :align => :justify
    end

    text_box "Recibido por _____________________________", at: [350,cursor + 70], inline_format: true

    # fill_color '1A135C'

    # text_box "<b>2019 - 20 Años propiciando seguridad, confianza y transparencia</b>", inline_format: true, at: [170,10]
  end
  
  def page_two
    start_new_page

    logo

    fill_color '1A135C'

    text_box "<b>Fecha de impresión: #{Time.now.strftime('%d/%m/%Y %I:%M:%S %p')}</b>", inline_format: true, at: [380,750]

    text_box "<b>Copia recaudación</b>", inline_format: true, at: [478,740]

    text_box "<b>REPÚBLICA DE PANAMÁ</b>
    <b>SUPERINTENDENCIA DEL MERCADO DE VALORES</b>
    <b>DEPARTAMENTO DE TESORERÍA</b>", inline_format: true, at: [10,700], :align => :center

    text_box "<b>RECIBO DE INGRESO</b>", inline_format: true, at: [10,665], :align => :center

    stroke do
      move_down 20
      horizontal_rule
    end

    move_down 10

    fill_color '000000'
  

    bounding_box([0, cursor], :width => 165, :height => 40) do
      # stroke_bounds
    
      poly_name = "#{@t_persona.try(:nombre)} #{@t_persona.try(:apellido)} #{@t_empresa.try(:razon_social)}"

      text_box "<b>Cliente:</b> #{@t_cliente.codigo}
      <b>Nombre:</b> #{poly_name.strip!}
      ", inline_format: true, at: [5, cursor], :align => :justify
    end

    bounding_box([185, 644], :width => 165, :height => 40) do
      # stroke_bounds
      text_box "<b>Referencia:</b>
      <b>CIP/RUC:</b> #{@t_empresa.try(:rif)}#{@t_persona.try(:cedula)}
      ", inline_format: true, at: [5, cursor], :align => :justify
    end

    bounding_box([370, 644], :width => 165, :height => 40) do
      # stroke_bounds
      text_box "<b>Recibo:</b> #{@t_recibo.id}
      <b>Estado:</b> #{(@t_recibo.pago_pendiente <= 0) ? 'Pagado' : 'Sin Pagar'}
      <b>Fecha:</b> #{@t_recibo.created_at.strftime('%d/%m/%Y %I:%M:%S %p')}
      ", inline_format: true, at: [5, cursor], :align => :justify
    end

    big_table_for_5_with_widths_and_alignment(
      bold("Cantidad"), 
      bold("Ítem"), 
      bold("Descripción"), 
      bold("Precio"), 
      bold("Saldo"),
      45, 130, 240, 70, :center)

    @t_factura.t_factura_detalles.each do |fd|
      big_table_for_5_with_widths_and_alignment(
        "#{fd.cantidad}", 
        "#{fd.t_tarifa_servicio.nombre}", 
        "#{fd.cuenta_desc}", 
        "#{fd.precio_unitario}", 
        "#{fd.precio_unitario * fd.cantidad}", 
        45, 130, 240, 70, :center)
    end

    @t_factura.t_recargos.each do |r|
      big_table_for_5_with_widths_and_alignment(
        "", 
        "Recargo", 
        "#{r.descripcion}", 
        "#{r.tasa * @t_factura.calculate_services_total_price}", 
        "",
        45, 130, 240, 70, :center)
    end  

    move_down 30

    bounding_box([0, cursor], :width => 270, :height => 110) do
        num_cheque = @t_recibo.t_metodo_pago.forma_pago == "Cheque" ? "<b>N° de cheque:</b> #{@t_recibo.num_cheque}" : ""
        # stroke_bounds
        text_box "<b>Método de Pago:</b> #{@t_recibo.t_metodo_pago.forma_pago}
        #{num_cheque}", inline_format: true, at: [5, cursor], :align => :justify
    end

    move_up 110

    table_for_2_with_widths_and_height_and_alignment_to_the_right(
      bold("Total Factura:"),
      bold("#{@t_factura.total_factura}"),
      110, 110, 20, :center)

    if @t_recibo.t_nota_creditos.count == 0
      monto_pendiente = @t_factura.pendiente_total + @t_recibo.pago_recibido
    else
      monto_pendiente = @t_recibo.t_nota_creditos.sum(:monto) + @t_recibo.pago_recibido
    end

    table_for_2_with_widths_and_height_and_alignment_to_the_right(
      bold("Pendiente Factura:"),
      bold("#{@t_factura.monto_pendiente_para_pdf}"),
      110, 110, 20, :center)

    table_for_2_with_widths_and_height_and_alignment_to_the_right(
      bold("Pago Recibido:"),
      bold("#{@t_recibo.pago_recibido}"),
      110, 110, 20, :center)

    table_for_2_with_widths_and_height_and_alignment_to_the_right(
      bold("Saldo Pendiente:"),
      bold("#{@t_factura.pendiente_total}"),
      110, 110, 20, :center)

    stroke do
      move_down 10
      horizontal_rule
    end

    move_down 20

    bounding_box([0, cursor], :width => bounds.width, :height => 70) do
        # stroke_bounds
        text_box "<b>Cajero(a):</b> #{@current_user.nombre} #{@current_user.apellido}                                                                                                                                 
        
        <b>IMPORTANTE:</b> Verifique que el nombre en el presente recibo haya sido escrito de la forma correcta. En caso de una devolución, la misma se realizará a nombre de quien aparece en este recibo de pago.", inline_format: true, at: [5, cursor], :align => :justify
    end


    text_box "Recibido por _____________________________", at: [350,cursor + 70], inline_format: true

    # fill_color '1A135C'

    # text_box "<b>2019 - 20 Años propiciando seguridad, confianza y transparencia</b>", inline_format: true, at: [170,10]
  end

  def page_three
    start_new_page

    logo

    fill_color '1A135C'

    text_box "<b>Fecha de impresión: #{Time.now.strftime('%d/%m/%Y %I:%M:%S %p')}</b>", inline_format: true, at: [380,750]

    text_box "<b>REPÚBLICA DE PANAMÁ</b>
    <b>SUPERINTENDENCIA DEL MERCADO DE VALORES</b>
    <b>DEPARTAMENTO DE TESORERÍA</b>", inline_format: true, at: [10,700], :align => :center

    text_box "<b>RECIBO DE INGRESO</b>", inline_format: true, at: [10,665], :align => :center

    text_box "<b>Copia CXC</b>", inline_format: true, at: [508,740]

    stroke do
      move_down 20
      horizontal_rule
    end

    move_down 10

    fill_color '000000'
  

    bounding_box([0, cursor], :width => 165, :height => 40) do
      # stroke_bounds
    
      poly_name = "#{@t_persona.try(:nombre)} #{@t_persona.try(:apellido)} #{@t_empresa.try(:razon_social)}"

      text_box "<b>Cliente:</b> #{@t_cliente.codigo}
      <b>Nombre:</b> #{poly_name.strip!}
      ", inline_format: true, at: [5, cursor], :align => :justify
    end

    bounding_box([185, 644], :width => 165, :height => 40) do
      # stroke_bounds
      text_box "<b>Referencia:</b>
      <b>CIP/RUC:</b> #{@t_empresa.try(:rif)}#{@t_persona.try(:cedula)}
      ", inline_format: true, at: [5, cursor], :align => :justify
    end

    bounding_box([370, 644], :width => 165, :height => 40) do
      # stroke_bounds
      text_box "<b>Recibo:</b> #{@t_recibo.id}
      <b>Estado:</b> #{(@t_recibo.pago_pendiente <= 0) ? 'Pagado' : 'Sin Pagar'}
      <b>Fecha:</b> #{@t_recibo.created_at.strftime('%d/%m/%Y %I:%M:%S %p')}
      ", inline_format: true, at: [5, cursor], :align => :justify
    end


    big_table_for_5_with_widths_and_alignment(
      bold("Cantidad"), 
      bold("Ítem"), 
      bold("Descripción"), 
      bold("Precio"), 
      bold("Saldo"),
      45, 130, 240, 70, :center)

    @t_factura.t_factura_detalles.each do |fd|
      big_table_for_5_with_widths_and_alignment(
        "#{fd.cantidad}", 
        "#{fd.t_tarifa_servicio.nombre}", 
        "#{fd.cuenta_desc}", 
        "#{fd.precio_unitario}", 
        "#{fd.precio_unitario * fd.cantidad}", 
        45, 130, 240, 70, :center)
    end

    @t_factura.t_recargos.each do |r|
      big_table_for_5_with_widths_and_alignment(
        "", 
        "Recargo", 
        "#{r.descripcion}", 
        "#{r.tasa * @t_factura.calculate_services_total_price}", 
        "",
        45, 130, 240, 70, :center)
    end    
    #######
    #Loop here plz
    #######

    move_down 30

    bounding_box([0, cursor], :width => 270, :height => 110) do
        num_cheque = @t_recibo.t_metodo_pago.forma_pago == "Cheque" ? "<b>N° de cheque:</b> #{@t_recibo.num_cheque}" : ""
        # stroke_bounds
        text_box "<b>Método de Pago:</b> #{@t_recibo.t_metodo_pago.forma_pago}
        #{num_cheque}", inline_format: true, at: [5, cursor], :align => :justify
    end

    move_up 110

    table_for_2_with_widths_and_height_and_alignment_to_the_right(
      bold("Total Factura:"),
      bold("#{@t_factura.total_factura}"),
      110, 110, 20, :center)

    if @t_recibo.t_nota_creditos.count == 0
      monto_pendiente = @t_factura.pendiente_total + @t_recibo.pago_recibido
    else
      monto_pendiente = @t_recibo.t_nota_creditos.sum(:monto) + @t_recibo.pago_recibido
    end

    table_for_2_with_widths_and_height_and_alignment_to_the_right(
      bold("Pendiente Factura:"),
      bold("#{@t_factura.monto_pendiente_para_pdf}"),
      110, 110, 20, :center)

    table_for_2_with_widths_and_height_and_alignment_to_the_right(
      bold("Pago Recibido:"),
      bold("#{@t_recibo.pago_recibido}"),
      110, 110, 20, :center)

    table_for_2_with_widths_and_height_and_alignment_to_the_right(
      bold("Saldo Pendiente:"),
      bold("#{@t_factura.pendiente_total}"),
      110, 110, 20, :center)

    stroke do
      move_down 10
      horizontal_rule
    end

    move_down 20
    bounding_box([0, cursor], :width => bounds.width, :height => 70) do
        # stroke_bounds
        text_box "<b>Cajero(a):</b> #{@current_user.nombre} #{@current_user.apellido}                                                                                                                                 
        
        <b>IMPORTANTE:</b> Verifique que el nombre en el presente recibo haya sido escrito de la forma correcta. En caso de una devolución, la misma se realizará a nombre de quien aparece en este recibo de pago.", inline_format: true, at: [5, cursor], :align => :justify
    end

    text_box "Recibido por _____________________________", at: [350,cursor + 70], inline_format: true

    # fill_color '1A135C'

    # text_box "<b>2019 - 20 Años propiciando seguridad, confianza y transparencia</b>", inline_format: true, at: [170,10]
  end
end

