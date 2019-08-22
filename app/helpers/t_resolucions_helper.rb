module TResolucionsHelper

  def opciones_de_anios_para_resolucion
    time = Time.new
    optiones = []
    for item in 0..2 do
      optiones.push([time.year - item])
    end
    return optiones
  end

end