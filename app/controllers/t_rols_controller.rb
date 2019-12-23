class TRolsController < ApplicationController
  before_action :set_t_rol, only: [:edit, :update, :show, :modules, :permissions, :destroy]
  load_and_authorize_resource

  def new
    @t_rol = TRol.new
  end

  def create
    @t_rol = TRol.new(t_rol_params)

    if @t_rol.save
      redirect_to @t_rol, notice: 'Rol de usuario creado exitosamente'
    else
      @notice = @rol.errors
      render 'new'
    end
  end

  def index
    @usar_dataTables = true
    @attributes_to_display = [:nombre, :descripcion, :estatus]

    respond_to do |format|
      format.html
      format.json { render json: ApplicationDatatable.new(
        params.merge({ attributes_to_display: @attributes_to_display }),
        view_context: view_context)
      }
    end
  end

  def show
  end

  def edit
  end

  def update
    if @t_rol.update(t_rol_params)
      redirect_to @t_rol, notice: 'Rol actualizado exitosamente'
    else
      render 'edit'
    end
  end

  def modules
  end

  def permissions
  end

  def destroy
    @t_rol.destroy

    redirect_to t_rols_path
  end

  private
    def t_rol_params
      params.require(:t_rol).permit(
        :nombre, :descripcion, :estatus, {t_modulo_ids: []},
        t_modulo_rols_attributes: [:id, t_permiso_ids: []]
      )
    end

    def set_t_rol
      @t_rol = TRol.find(params[:id])
    end
end
