class TRolsController < ApplicationController

  before_action :set_t_rol, only: [:edit, :update, :destroy]

  load_and_authorize_resource

  rescue_from CanCan::AccessDenied do |exception|
		redirect_to dashboard_access_denied_path, :alert => exception.message
	end

  def index
    @usar_dataTables = true
    @rols = TRol.all
  end

  def show
    @rol =TRol.find(params[:id])
  end

  def new
    @rol=TRol.new
  end

  def create
    @rol = TRol.new(t_rols_params)

    @rol.estatus = params[:is_active] == "Activo"? true : false

    if @rol.save
      redirect_to rols_index_path, notice: 'Rol de usuario creado correctamente.'
    else
      @notice = @rol.errors
      render :action => "new"
    end
  end

  def edit
    @rol =TRol.find(params[:id])
    @elementos = TElemento.all
  end

  def update
    @rol = TRol.find(params[:id])

    if params[:is_active] == "Activo" or params[:is_active] == "Inactivo"
      @rol.estatus = params[:is_active] == "Activo"? true : false
    end

    if @rol.update_attributes(t_rols_params)
      if @rol.associate_rol_with_elements(params[:id], params[:actions_by_rol])
        redirect_to rols_index_path , notice: 'Rol de usuario actualizado correctamente.'
      else
        @notice = @rol.errors
        render :action => "edit"
      end
    else
      @notice = @rol.errors
      render :action => "edit"
    end
  end

  def destroy
    @rol = TRol.find(params[:id])
    @rol.delete
    redirect_to(:action => 'index')
  end

  private
    def t_rols_params
      params.require(:rol).permit(:direccion_url, :li_class, :i_class, :u_class, :nombre, :descripcion, :peso, :estatus, :icon_class)
    end

    def set_t_rol
      @rol = TRol.find(params[:id])
    end

end
