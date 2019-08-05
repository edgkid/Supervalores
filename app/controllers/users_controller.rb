# require "user.rb"
class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all
  end

  def show
    @user =User.find(params[:id])
    #user_rol = @user.get_user_rol(params[:id])

  end

  # GET /users/new
  def new
    @user = User.new
    @rols = @user.get_all_rols
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    
    if @user.save!
      redirect_to(:action => 'index')
    else
      render action: 'new'
    end

  end

  def update

  end

  def destroy
    @user = User.find(params[:id])
    @user.delete
    redirect_to(:action => 'index')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:nombre, :apellido, :estado, :email, :encrypted_password)
    end
end
