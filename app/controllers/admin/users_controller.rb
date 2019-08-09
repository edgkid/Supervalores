class Admin::UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @usar_dataTables = true
    @users = User.all
    @notice = "Lista de usuarios registrados"
  end

  def new
    @user = User.new
    @rols = TRol.all
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to admin_users_path, notice: 'Usuario creado correctamente.'
    else
      @notice = @user.errors
      redirect_to :action => 'new'
    end
  end

  def edit
    @notice = Notice.new("Cuidado", "Estas modificando la informacion de #{@user.nombre}, #{@user.apellido}", "warning")
  end

  def update    
    if @user.update(user_params)
      # flash[:success] = "El usuario ha sido modificado exitosamente"
      redirect_to admin_users_path, notice: 'Usuario actualizado correctamente.'
    else
      @notice = @user.errors
      # flash.now[:danger] = "El usuario no se pudo modificar, por favor revise los campos"
      #redirect_to edit_admin_user_path, notice: {title: "Cuarentena", message: @user.errors.inspect, type: "warning"}
      redirect_to edit_admin_user_path
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
