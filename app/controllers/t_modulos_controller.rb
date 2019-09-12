class TModulosController < ApplicationController
  def index
    @usar_dataTables = true
    @t_modulos = TModulo.all
  end
end
