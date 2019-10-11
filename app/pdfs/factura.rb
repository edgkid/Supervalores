class Factura < Prawn::Document

    # Constants
    GREEN = '00B700'
    DARK_GREEN = '00B800'

    # Constructor
    def initialize(request)
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
        data = [["OFICIAL CTA:"]]
        table(data, :cell_style => {:size => 6, :valign =>:left, :border_width => 0.1, :height => 15}, :width => 50)
    end


end