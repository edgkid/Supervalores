module TPeriodosHelper

  def opciones_de_mes_tope
    return [
      ["Enero", 1],
      ["Febrero", 2],
      ["Marzo", 3],
      ["Abril", 4],
      ["Mayo", 5],
      ["Junio", 6],
      ["Julio", 7],
      ["Agosto", 8],
      ["Septiembre", 9],
      ["Octubre", 10],
      ["Noviembre", 11],
      ["Diciembre", 12]
    ]
  end

  def mes_tope_text mes
    return mes == 1 ? "Enero" 
          : mes == 2 ? "Febrero" 
          : mes == 3 ? "Marzo" 
          : mes == 4 ? "Abril" 
          : mes == 5 ? "Mayo" 
          : mes == 6 ? "Junio" 
          : mes == 7 ? "Julio" 
          : mes == 8 ? "Agosto" 
          : mes == 9 ? "Septiembre" 
          : mes == 10 ? "Octubre" 
          : mes == 11 ? "Noviembre" 
          : mes == 12 ? "Diciembre" 
          : "Sin determinar"
  end
end