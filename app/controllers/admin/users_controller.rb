class Admin::UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  load_and_authorize_resource

  def index
    @usar_dataTables = true
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to admin_users_path, notice: 'Usuario creado exitosamente'
    else
      @notice = @user.errors
      render 'new'
    end
  end

  def edit
  end

  def update
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    if @user.update(user_params)
      redirect_to [:admin, @user], notice: 'Usuario actualizado correctamente.'
    else
      @notice = @user.errors
      render 'edit'
    end
  end

  def destroy
    @user.delete
    redirect_to admin_users_path, notice: 'Usuario eliminado exitosamente'
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(
        :nombre, :apellido, :estatus,
        :email, :password, :password_confirmation,
        :picture, t_rol_ids: [])
    end
end
