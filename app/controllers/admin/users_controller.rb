class Admin::UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all
  end

  def new
    @user = User.new
    @rols = TRol.all
  end

  def create
    @user = User.new(user_params)

    if @user.save
      # flash[:success] = "El usuario ha sido creado exitosamente"
      redirect_to admin_users_path
    else
      # flash.now[:danger] = "El usuario no se pudo crear, por favor revise los campos"
      redirect_to new_admin_user_path
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      # flash[:success] = "El usuario ha sido modificado exitosamente"
      redirect_to admin_users_path
    else
      # flash.now[:danger] = "El usuario no se pudo modificar, por favor revise los campos"
      render 'edit'
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
