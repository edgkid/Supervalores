class Factura < Prawn::Document

    require "prawn/measurement_extensions"
    require 'prawn/table'

    # Constants
    GREEN = '00B700'
    DARK_GREEN = '00B800'

    # Constructor
    def initialize 
        super()       
        document_content
    end

    def document_content
        page_one
    end

    def page_one
        text "El suscrito mayor de edad,", inline_format: true, align: :justify
    end


end