require "user.rb"
class TUsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render 'views/users/index'
    else
      render action: 'new'
    end
  end

  def edit
  end
end
