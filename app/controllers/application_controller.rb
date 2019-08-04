class ApplicationController < ActionController::Base

  skip_before_action :verify_authenticity_token, raise: false
  protect_from_forgery with: :null_session, except: [:create, :new, :edit, :update, :sign_in, :authenticate_user]
  before_action :authenticate_user!
end
