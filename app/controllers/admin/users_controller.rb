class Admin::UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @usar_dataTables = true
    @users = User.all
    @notice = "Lista de usuarios registrados"
  end

  def show

  end

  def new
    @user = User.new
    #@rols = TRol.all
  end

  def create
    @user = User.new(user_params)

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
