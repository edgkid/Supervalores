class Factura < Prawn::Document

    require "prawn/measurement_extensions"
    require 'prawn/table'

    # Constants
    GREEN = '00B700'
    DARK_GREEN = '00B800'

    # Constructor
    def initialize        
        document_content
    end

    def document_content
        page_one
    end

    def page_one
        text "Hello World!"
    end


end