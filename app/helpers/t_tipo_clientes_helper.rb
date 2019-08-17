module TTipoClientesHelper

  def opciones_de_tipos_para_tipos_de_clientes
    return TTipoClienteTipo.where(estatus: 1).order(:descripcion).pluck :descripcion, :id
  end

end
