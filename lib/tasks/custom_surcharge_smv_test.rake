namespace :db do
  desc "Generacion de recargos"

  task custom_surcharge_smv_test: :environment do
    # ActiveRecord::Base.transaction do
      generate_surcharge
      # load_countries
      # load_country_states
    # end
  end

  def clear_and_reset(classname)
    print "#{classname},"
    classname.classify.constantize.unscoped.destroy_all
    table = (classname == "Attachment") ? "attachment_names" : classname.tableize
    ActiveRecord::Base.connection.reset_pk_sequence!(table)
  end

  def load_countries
    puts "Cargando la tabla paises desde #{COUNTRIES_AND_STATES}"
    file = Roo::Excelx.new(COUNTRIES_AND_STATES)
    file.default_sheet = file.sheets[0]

    total = 0
    #Los contadores c1 y c2 serviran de guia para saber si se creo o se actualizo cada pais
    c1 = 0
    c2 = 0

    clear_and_reset("Country")

    2.upto(file.last_row) do |l|
      total += 1

      code = file.cell(l, CODIGO).strip
      name_en = file.cell(l, NAME_EN).titleize
      name_es = file.cell(l, NAME_ES).titleize
      country = Country.find_by_code(code)

      if country.nil?
        new_country = Country.new(code: code, name_en: name_en, name_es: name_es, active: true) 
        new_country.save!
        puts "Se creo code: #{code}, name_es: #{name_es}"
        c1 += 1
      else
        country.name_en = name_en
        country.name_es = name_es
        country.save!
        puts "Se actualizo code: #{code}, name_es: #{name_es}"
        c2 += 1
      end
    end
    puts "Se crearon: #{c1} paises"
    puts "Se actualizaron: #{c2} paises"
  end

  def load_country_states
    puts "Cargando la tabla estados desde '#{COUNTRIES_AND_STATES}'"
    file = Roo::Excelx.new(COUNTRIES_AND_STATES)
    file.default_sheet = file.sheets[1]

    total = 0
    #Los contadores c1 y c2 serviran de guia para saber si se creo o se actualizo cada estado
    c1 = 0
    c2 = 0

    clear_and_reset("CountryState")

    2.upto(file.last_row) do |l|
      total += 1
      
      code = file.cell(l, CODIGO).strip
      name_en = file.cell(l, NAME_EN).titleize
      name_es = file.cell(l, NAME_ES).titleize
      country_code = file.cell(l, COUNTRY_CODE)
      state = CountryState.find_by_code(code)

      if state.nil?
        new_state = CountryState.new(code: code, name_en: name_en, name_es: name_es, active: true, country_code: country_code) 
        new_state.save!
        puts "Se creo code: #{code}, name_es: #{name_es}"
        c1 += 1
      else
        state.name_en = name_en
        state.name_es = name_es
        state.country_code = country_code
        state.save!
        puts "Se actualizo code: #{code}, name_es: #{name_es}"
        c2 += 1
      end
    end
    puts "Se crearon: #{c1} estados"
    puts "Se actualizaron: #{c2} estados"
  end

  def generate_surcharge
    #5 y 8
    tipo_de_cliente = 13
    facturas = TFactura.joins(:t_resolucion).where(:t_resolucions => {t_tipo_cliente_id: tipo_de_cliente})
    # puts "#{facturas.ids}"
    facturas_procesadas = 0
    facturas_pagadas_completamente = 0
    facturas.each do |factura|
      sleep(0.5)
      # debugger
      unless factura.t_recibos.blank?
        # debugger if factura.t_recibos.order("created_at ASC").last.nil?
        ultimo_recibo = factura.t_recibos.order("created_at ASC").last
        if ultimo_recibo.pago_pendiente == 0
          facturas_pagadas_completamente += 1
          next
        end
        ultimo_recibo.recargo_x_pagar = 0
        ultimo_recibo.servicios_x_pagar = 0
        ultimo_recibo.save!
      end
      factura.t_recibos.last
      # factura.fecha_vencimiento = Date.strptime("12-10-2019", "%d-%m-%Y")
      # factura.save!
      # debugger
      factura.schedule_custom_percent_monthly_surcharge(0.02)
      facturas_procesadas += 1
      puts "#{facturas_procesadas} de #{facturas.count} || Factura Actual ID: #{factura.id}"
    end
    sleep(5)
    puts "Recargos Generados: #{facturas_procesadas} || Facturas Sin Pendiente: #{facturas_pagadas_completamente}"
    # puts "facturas con estatuses validos: #{facturas.where(t_estatus_id: [1,2,4, 5, 8,9, 10]).count}"
    # puts "#{facturas.ids}"
  end

end
