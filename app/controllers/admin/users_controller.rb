class Admin::UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @usar_dataTables = true
    @users = User.all
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
      redirect_to new_admin_user_path,  @user
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admin_users_path, notice: 'Usuario actualizado correctamente.'
    else
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
