module TEstatusesHelper
  
  def opciones_para
    return [
      ["Todos", 0], 
      ["Solo facturas", 1], 
      ["Solo clientes", 2], 
      ["Solo resoluciones", 3]
    ]
  end

  def para_text para
    return para == 0 ? "Todos" 
          : para == 1 ? "Solo facturas" 
          : para == 2 ? "Solo clientes" 
          : para == 3 ? "Solo resoluciones" 
          : "Sin determinar"
  end
end
