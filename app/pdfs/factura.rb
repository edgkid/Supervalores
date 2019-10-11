class Factura < Prawn::Document

    require "prawn/measurement_extensions"
    require 'prawn/table'
    
    # Constants
    GREEN = '00B700'
    DARK_GREEN = '00B800'

    # Constructor
    def initialize
        # Call parent constructor
        super()

        # Set document font
        font 'DejaVuSans', type: :normal
        font_size 9
        
        # Put document body
        document_content
    end

    def document_content
        page_one
    end

    def page_one
        text "Hello World!"
    end


end