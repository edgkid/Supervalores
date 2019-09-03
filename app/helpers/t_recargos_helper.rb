module TRecargosHelper
  def opciones_de_recargos
    TRecargo.pluck(:descripcion, :id)
  end
end
