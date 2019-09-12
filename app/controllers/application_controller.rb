class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token, raise: false
  protect_from_forgery with: :null_session, except: [:create, :new, :edit, :update, :sign_in, :authenticate_user]
  before_action :authenticate_user!

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :nombre, :apellido, :estado, :password, :password_confirmation
    ])
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, notice: 'No tiene permitido entrar ahí'# denied_path, alert: exception.message
  end
end
