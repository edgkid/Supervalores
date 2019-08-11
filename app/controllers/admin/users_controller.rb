class Admin::UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @usar_dataTables = true
    @users = User.all
    @notice = "Lista de usuarios registrados"
  end

  def show
    rol_info = @user.get_user_rol(params[:id])
    @rol = TRol.new
    if rol_info != nil
      @rol.nombre = rol_info[0]['nombre']
      @rol.descripcion = rol_info[0]['descripcion']
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    @user.estado = params[:is_active] == "Activo"? true : false

    if @user.save
        redirect_to admin_users_path, notice: 'Usuario creado correctamente.'
    else
      @notice = @user.errors
      render :action => "new"
    end
  end

  def edit
    @rols = TRol.all
  end

  def update
    @rols = TRol.all
    
    if params[:is_active] == "Activo" or params[:is_active] == "Inactivo"
      @user.estado = params[:is_active] == "Activo"? true : false
    end

    if @user.update(user_params)

      if @user.associate_rol_and_user(params[:id_rol], params[:id])
        redirect_to admin_users_path, notice: 'Usuario actualizado correctamente.'
      else
        render :action => "edit"
      end
    else
      @notice = @user.errors
      render :action => "edit"
    end
  end

  def destroy
    @user.delete
    # flash[:warning] = "Usuario eliminado para siempre"
    redirect_to admin_users_path
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:nombre, :apellido, :estado, :email, :password, :password_confirmation)
    end
end
