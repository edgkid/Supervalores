class PdfHelper < Prawn::Document
    require "prawn/measurement_extensions"
    require 'prawn/table'


    def initialize(options = {})
        # Merge defaults with options
        defaults = {
            page_size: 'LETTER',
            top_margin: 1.cm,
            right_margin: 1.cm,
            bottom_margin: 1.cm,
            left_margin: 1.cm,
        }.merge!(options)

        # Create document with options
        super(defaults)

    end


    def data_table(data, options = {})
        default_column_widths = []
        # Check width
        width = (options[:space])? (bounds.width - options[:space]) : bounds.width
        unless options[:column_widths]
            data.size.times do
                default_column_widths << (width/data[0].size).to_f
            end
        end
        defaults = {
            cell_style: {
                align: :center,
                inline_format: true,
                #size: 7,
            },
            column_widths: default_column_widths,
            position: :center,
            space: 0,
            custom_row_styles: {},
            custom_col_styles: {},
        }.deep_merge!(options)
        table_width = bounds.right - defaults[:space]
        defaults[:column_widths] = defaults[:column_widths].map{|value| value*table_width} if options[:column_widths]
        table(data, cell_style: defaults[:cell_style], column_widths: defaults[:column_widths], position: defaults[:position]) do
            row(0).columns(0).borders = [:bottom, :right] if data[0][0].empty?

            # Apply custom styles to rows and cols
            cells.each do |c|
                ro = defaults[:custom_row_styles][c.row]
                co = defaults[:custom_col_styles][c.column]
                if ro
                    ro.each do |cols, style|
                        row(c.row).columns(cols).style(style)
                    end
                end
                if co
                    co.each do |ros, style|
                        column(c.column).rows(ros).style(style)
                    end
                end
            end
        end
    end

    def data_table_header_with_color(data, options = {})
        default_column_widths = []
        # Check width
        width = (options[:space])? (bounds.width - options[:space]) : bounds.width
        unless options[:column_widths]
            data.size.times do
                default_column_widths << (width/data[0].size).to_f
            end
        end
        defaults = {
            cell_style: {
                align: :center,
                inline_format: true,
                size: 7,
            },
            column_widths: default_column_widths,
            header_bg_color: '00B050',
            header_ft_color: 'FFFFFF',
            position: :center,
            space: 0,
            custom_row_styles: {},
            custom_col_styles: {},
        }.deep_merge!(options)
        table_width = bounds.right - defaults[:space]
        defaults[:column_widths] = defaults[:column_widths].map{|value| value*table_width} if options[:column_widths]
        table(data, cell_style: defaults[:cell_style], column_widths: defaults[:column_widths], position: defaults[:position]) do
            row(0).style({
                background_color: defaults[:header_bg_color],
                font_style: :bold,
                text_color: defaults[:header_ft_color],
            })
            
            # Apply custom styles to rows and cols
            cells.each do |c|
                ro = defaults[:custom_row_styles][c.row]
                co = defaults[:custom_col_styles][c.column]
                if ro
                    ro.each do |elem, val|
                        row(c.row).columns(elem).style(val)
                    end
                end
                if co
                    co.each do |elem, val|
                        column(c.column).rows(elem).style(val)
                    end
                end
            end
        end
    end

    def inline_sign_field(prefix, content = "", propotion = [], font_size = 10)
        data_table([
            [
                {content: prefix, borders: [], valign: :center, size: font_size},
                {content: content, borders: [:bottom]},
            ]
        ], {
            column_widths: (propotion.empty? ? [0.50, 0.50] : propotion)
        })
    end

    def bold(var)
        "<b>" + var + "</b>"
    end

    def title_and_text_placement(title,text_placement)
        stroke do
            fill_color '0E7250'
            fill_and_stroke_rectangle [0, cursor], bounds.width, 13
        end
        move_down 3
        fill_color "FFFFFF"
        text_box title, size: 10, align: text_placement, style: :bold, :at => [9, cursor]
        move_down 10
    end

    def big_title_and_text_placement(title,text_placement)
        stroke do
            fill_color '0E7250'
            fill_and_stroke_rectangle [0, cursor], bounds.width, 30
        end
        move_down 8
        fill_color "FFFFFF"
        text_box title, size: 10, align: text_placement, style: :bold, :at => [9, cursor]
        move_down 22
    end

    def table_for_1_auto_adjust(text1)
        fill_color '000000'
        data = [[text1]]
        table(data, :cell_style => {:inline_format => true, :border_width => 0.1, :align => :left}, width: bounds.width )
    end

    def table_for_1_with_height_and_alignment(text1,height1,align1)
        fill_color '000000'
        data = [[text1]]
        table(data, :cell_style => {:inline_format => true, :border_width => 0.1, :align => align1, :height=>height1}, width: bounds.width )
    end


    def table_for_2(text1,text2)
        fill_color '000000'
        data = [[text1,text2]]
        table(data, :cell_style => {:inline_format => true, :border_width => 0.1, :align => :center}, width: bounds.width )
    end


    def table_for_2_with_widths_and_height_and_alignment(text1,text2,width1,height1,align1)
        fill_color '000000'
        data = [[text1,text2]]
        table(data, :column_widths => [width1, bounds.width-width1],
          :cell_style => {:inline_format => true, :border_width => 0.1, :align => align1,:height => height1}, width: bounds.width, )
    end

    def table_for_2_with_widths_and_height_and_alignment_light_gray(text1,text2,width1,height1,align1)
        fill_color '000000'
        data = [[text1,text2]]
        table(data, :column_widths => [width1, bounds.width-width1],
          :cell_style => {:inline_format => true,:background_color => 'F0F2F2', :border_width => 0.1, :align => align1,:height => height1},
           width: bounds.width)
    end


    def big_table_for_3_with_widths_and_alignment_and_height(text1,text2,text3,width1,width2,align1,height1)
        fill_color '000000'
        data = [[text1,text2,text3]]
        table(data, :column_widths => [width1,width2, bounds.width-width1-width2],
          :cell_style => {:inline_format => true, :border_width => 0.1, :align => align1, :height=> height1 }, width: bounds.width )
    end

    def big_table_for_3_with_widths_and_alignment_and_height_light_gray(text1,text2,text3,width1,width2,align1,height1)
        fill_color '000000'
        data = [[text1,text2,text3]]
        table(data, :column_widths => [width1,width2, bounds.width-width1-width2],
          :cell_style => {:inline_format => true,:background_color => 'F0F2F2', :border_width => 0.1, :align => align1, :height=> height1},
           width: bounds.width )
    end

    def table_for_4(text1,text2,text3,text4)
        fill_color '000000'
        data = [[text1,text2,text3,text4]]
        table(data, :cell_style => {:inline_format => true, :border_width => 0.1, :align => :left}, width: bounds.width )
    end

    def big_table_for_4_with_widths_and_alignment_and_height(text1,text2,text3,text4,width1,width2,width3,align1,height1)
        fill_color '000000'
        data = [[text1,text2,text3,text4]]
        table(data, :column_widths => [width1,width2,width3, bounds.width-width1-width2-width3],
          :cell_style => {:inline_format => true, :border_width => 0.1, :align => align1, :height=> height1}, width: bounds.width )
    end

    def big_table_for_4_with_widths_and_alignment_and_height_light_gray(text1,text2,text3,text4,width1,width2,width3,align1,height1)
        fill_color '000000'
        data = [[text1,text2,text3,text4]]
        table(data, :column_widths => [width1,width2,width3, bounds.width-width1-width2-width3],
          :cell_style => {:inline_format => true,:background_color => 'F0F2F2', :border_width => 0.1, :align => align1, :height=> height1},
           width: bounds.width )
    end

    def big_table_for_5_with_widths_and_alignment_and_height(text1,text2,text3,text4,text5,width1,width2,width3,width4,align1,height1)
        fill_color '000000'
        data = [[text1,text2,text3,text4,text5]]
        table(data, :column_widths => [width1,width2,width3,width4, bounds.width-width1-width2-width3-width4],
          :cell_style => {:inline_format => true, :border_width => 0.1, :align => align1, :height=> height1}, width: bounds.width )
    end

    def big_table_for_5_with_widths_and_alignment_and_height_exception(text1,text2,text3,text4,text5,width1,width2,width3,width4,align1,height1)
        fill_color '000000'
        data = [[text1,text2,text3,text4,text5]]
        table(data, :column_widths => [width1,width2,width3,width4, bounds.width-width1-width2-width3-width4],
          :cell_style => {:inline_format => true, :border_width => 0.1, :align => align1, :height=> height1}, width: bounds.width )
    end

    def table_inside_a_table
        make_table( [ [
        "CÉDULA: #{@instance.formatted_identification}",
        "PASAPORTE: #{@instance.passport_number}"], 
        ["PAÍS EMISOR PASAPORTE: #{Carmen::Country.coded(@instance.country_of_passport_number_code).name.titleize}",
        "ID SEGUNDA NACIONALIDAD:\n"]
         ],
        :cell_style => {:padding_top => 1,:inline_format => true, :border_color => '000000', :height => 20},:column_widths => [135,135])
    end

    def yes_and_no_boxes(coordinates)
        fill_color 'FFFFFF'
        fill_and_stroke_rectangle [coordinates, cursor - 14], 10, 10   #[10, cursor-16], 10, 10
        fill_and_stroke_rectangle [coordinates + 25, cursor - 14], 10, 10   #[35, cursor-16], 10, 10
        fill_color '000000'
        draw_text "SI",
        :at => [coordinates + 13, cursor - 24], :size => 6    #[23, cursor - 24], :size => 6          
        draw_text "NO",
        :at => [coordinates + 38, cursor - 24], :size => 6    #[49, cursor - 24], :size => 6
    end

    def yes_and_no_boxes_with_height(coordinates, height)
        fill_color 'FFFFFF'
        fill_and_stroke_rectangle [coordinates, cursor - 16 - height], 10, 10   #[10, cursor-16], 10, 10
        fill_and_stroke_rectangle [coordinates + 25, cursor - 16 - height], 10, 10   #[35, cursor-16], 10, 10
        fill_color '000000'
        draw_text "SI",
        :at => [coordinates + 13, cursor - 24 - height], :size => 6    #[23, cursor - 24], :size => 6          
        draw_text "NO",
        :at => [coordinates + 38, cursor - 24 - height], :size => 6    #[49, cursor - 24], :size => 6
    end

    def one_option_boxes_with_height(text1,coordinates, height)
        fill_color 'FFFFFF'
        fill_and_stroke_rectangle [coordinates, cursor - 16 - height], 10, 10   #[10, cursor-16], 10, 10
        fill_color '000000'
        draw_text text1,
        :at => [coordinates + 13, cursor - 24 - height], :size => 6    #[23, cursor - 24], :size => 6          
    end

    def two_option_boxes_with_height_and_space(text1,text2,coordinates, height,space)
        fill_color 'FFFFFF'
        fill_and_stroke_rectangle [coordinates, cursor - 16 - height], 10, 10   #[10, cursor-16], 10, 10
        fill_and_stroke_rectangle [coordinates + space, cursor - 16 - height], 10, 10   #[35, cursor-16], 10, 10
        fill_color '000000'
        draw_text text1,
        :at => [coordinates + 13, cursor - 24 - height], :size => 6    #[23, cursor - 24], :size => 6          
        draw_text text2,
        :at => [coordinates + space+13, cursor - 24 - height], :size => 6    #[49, cursor - 24], :size => 6
    end

    def two_column_option_boxes_with_height(text1,text2,coordinates, height)
        fill_color 'FFFFFF'
        fill_and_stroke_rectangle [coordinates, cursor - 16 - height], 10, 10   #[10, cursor-16], 10, 10
        fill_and_stroke_rectangle [coordinates, cursor - height], 10, 10   #[35, cursor-16], 10, 10
        fill_color '000000'
        draw_text text1,
        :at => [coordinates + 13, cursor - 6 - height], :size => 6    #[23, cursor - 24], :size => 6          
        draw_text text2,
        :at => [coordinates + 13, cursor - 24 - height], :size => 6    #[49, cursor - 24], :size => 6
        fill_color 'FFFFFF'
    end

    def two_glued_column_option_boxes_with_height(text1,text2,coordinates, height)
        fill_color 'FFFFFF'
        fill_and_stroke_rectangle [coordinates, cursor - 11 - height], 10, 10   #[10, cursor-16], 10, 10
        fill_and_stroke_rectangle [coordinates, cursor - height], 10, 10   #[35, cursor-16], 10, 10
        fill_color '000000'
        draw_text text1,
        :at => [coordinates + 13, cursor - 6 - height], :size => 6    #[23, cursor - 24], :size => 6          
        draw_text text2,
        :at => [coordinates + 13, cursor - 18 - height], :size => 6    #[49, cursor - 24], :size => 6
    end

    def three_option_boxes_with_height_and_space(text1,text2,text3,coordinates, height,space)
        fill_color 'FFFFFF'
        fill_and_stroke_rectangle [coordinates, cursor - 16 - height], 10, 10   #[10, cursor-16], 10, 10
        fill_and_stroke_rectangle [coordinates + space, cursor - 16 - height], 10, 10   #[35, cursor-16], 10, 10
        fill_and_stroke_rectangle [coordinates + (space*2), cursor - 16 - height], 10, 10     
        fill_color '000000'
        draw_text text1,
        :at => [coordinates + 13, cursor - 24 - height], :size => 6    #[23, cursor - 24], :size => 6          
        draw_text text2,
        :at => [coordinates + space+13, cursor - 24 - height], :size => 6    #[49, cursor - 24], :size => 6
        fill_color '000000'
        draw_text text3,
        :at => [coordinates + (space*2)+13, cursor - 24 - height], :size => 6    #[49, cursor - 24], :size => 6
    end

    def four_option_boxes_with_height_and_space(text1,text2,text3,text4,text5,coordinates, height,space)
        fill_color 'FFFFFF'
        fill_and_stroke_rectangle [coordinates, cursor - 16 - height], 10, 10   #[10, cursor-16], 10, 10
        fill_and_stroke_rectangle [coordinates + space, cursor - 16 - height], 10, 10   #[35, cursor-16], 10, 10
        fill_and_stroke_rectangle [coordinates + (space*2), cursor - 16 - height], 10, 10   
        fill_and_stroke_rectangle [coordinates + (space*3), cursor - 16 - height], 10, 10    
        fill_color '000000'
        draw_text text1,
        :at => [coordinates + 13, cursor - 24 - height], :size => 6    #[23, cursor - 24], :size => 6          
        draw_text text2,
        :at => [coordinates + space+13, cursor - 24 - height], :size => 6    #[49, cursor - 24], :size => 6
        fill_color '000000'
        draw_text text3,
        :at => [coordinates + (space*2)+13, cursor - 24 - height], :size => 6    #[49, cursor - 24], :size => 6
        fill_color '000000'
        draw_text text4,
        :at => [coordinates + (space*3)+13, cursor - 24 - height], :size => 6    #[49, cursor - 24], :size => 6
    end

    def four_option_boxes_with_height_and_specific_spaces(text1,text2,text3,text4,coordinates, height,space1,space2,space3)
        fill_color 'FFFFFF'
        fill_and_stroke_rectangle [coordinates, cursor - 16 - height], 10, 10   #[10, cursor-16], 10, 10
        fill_and_stroke_rectangle [coordinates + space1, cursor - 16 - height], 10, 10   #[35, cursor-16], 10, 10
        fill_and_stroke_rectangle [coordinates + (space2*2), cursor - 16 - height], 10, 10   
        fill_and_stroke_rectangle [coordinates + (space3*3), cursor - 16 - height], 10, 10    
        fill_color '000000'
        draw_text text1,
        :at => [coordinates + 13, cursor - 24 - height], :size => 6    #[23, cursor - 24], :size => 6          
        draw_text text2,
        :at => [coordinates + space1 +13, cursor - 24 - height], :size => 6    #[49, cursor - 24], :size => 6
        fill_color '000000'
        draw_text text3,
        :at => [coordinates + (space2*2)+13, cursor - 24 - height], :size => 6    #[49, cursor - 24], :size => 6
        fill_color '000000'
        draw_text text4,
        :at => [coordinates + (space3*3)+13, cursor - 24 - height], :size => 6    #[49, cursor - 24], :size => 6
    end

    def four_column_option_boxes_with_height(text1,text2,text3,text4,coordinates, height)
        fill_color 'FFFFFF'
        fill_and_stroke_rectangle [coordinates, cursor - height], 10, 10
        fill_and_stroke_rectangle [coordinates, cursor - 12.5  - height], 10, 10 
        fill_and_stroke_rectangle [coordinates, cursor - 25 - height], 10, 10
        fill_and_stroke_rectangle [coordinates, cursor - 37.5 - height], 10, 10
        fill_color '000000'
        draw_text text1,
        :at => [coordinates + 13, cursor - 6 - height], :size => 6    #[23, cursor - 24], :size => 6          
        draw_text text2,
        :at => [coordinates + 13, cursor - 24 - height], :size => 6    #[49, cursor - 24], :size => 6
        draw_text text2,
        :at => [coordinates + 13, cursor - 42 - height], :size => 6
        draw_text text2,
        :at => [coordinates + 13, cursor - 60 - height], :size => 6
    end

    def five_option_boxes_with_height_and_space(text1,text2,text3,text4,text5,coordinates, height,space)
        fill_color 'FFFFFF'
        fill_and_stroke_rectangle [coordinates, cursor - 16 - height], 10, 10   #[10, cursor-16], 10, 10
        fill_and_stroke_rectangle [coordinates + space, cursor - 16 - height], 10, 10   #[35, cursor-16], 10, 10
        fill_and_stroke_rectangle [coordinates + (space*2), cursor - 16 - height], 10, 10   
        fill_and_stroke_rectangle [coordinates + (space*3), cursor - 16 - height], 10, 10  
        fill_and_stroke_rectangle [coordinates + (space*4), cursor - 16 - height], 10, 10  
        fill_color '000000'
        draw_text text1,
        :at => [coordinates + 13, cursor - 24 - height], :size => 6    #[23, cursor - 24], :size => 6          
        draw_text text2,
        :at => [coordinates + space+13, cursor - 24 - height], :size => 6    #[49, cursor - 24], :size => 6
        fill_color '000000'
        draw_text text3,
        :at => [coordinates + (space*2)+13, cursor - 24 - height], :size => 6    #[49, cursor - 24], :size => 6
        fill_color '000000'
        draw_text text4,
        :at => [coordinates + (space*3)+13, cursor - 24 - height], :size => 6    #[49, cursor - 24], :size => 6
        fill_color '000000'
        draw_text text5,
        :at => [coordinates + (space*4)+13, cursor - 24 - height], :size => 6    #[49, cursor - 24], :size => 6
        fill_color '000000'
    end

    def box_with_height(coordinates,height)
        fill_color 'FFFFFF'
        fill_and_stroke_rectangle [coordinates, cursor - 16 - height], 10, 10   #[10, cursor-16], 10, 10
    end

    def font_size_9(var)
        "<font size='8'>#{var}</font>"
    end
end