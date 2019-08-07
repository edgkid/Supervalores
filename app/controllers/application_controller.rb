class ApplicationController < ActionController::Base

  skip_before_action :verify_authenticity_token, raise: false
  protect_from_forgery with: :null_session, except: [:create, :new, :edit, :update, :sign_in, :authenticate_user]
  before_action :authenticate_user!

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :nombre, :apellido, :estado, :password, :password_confirmation
    ])
  end
end
