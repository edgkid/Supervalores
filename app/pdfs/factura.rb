class Factura < Prawn::Document

    require "prawn/measurement_extensions"
    require 'prawn/table'

    # Constants
    GREEN = '00B700'
    DARK_GREEN = '00B800'

    # Constructor
    def initialize 
        super()     
        font_size 8 
        document_content
        
    end

    def document_content
        logo
        page_one
    end

    def page_one
        fill_color '6D5F83'
        text_box "<b>REPÚBLICA DE PANAMÁ</b>
        <b>SUPERINTENDENCIA DEL MERCADO DE VALORES</b>
        <b>DEPARTAMENTO DE TESORERÍA</b>
        <b>RECIBO DE INGRESO</b>", inline_format: true, at: [10,700], :align => :center

        text_box "<b>Fecha de impresión: </b>", inline_format: true, at: [400,750]

        text_box "<b>Original Cliente</b>", inline_format: true, at: [480,740]
    end

    def logo
        image "#{Rails.root}/app/assets/images/logoSMV.png" , :fit => [130,130]
    end


end