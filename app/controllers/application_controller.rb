class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?


  def after_sign_up_path_for(resource)
    request.env['omniauth.origin'] || stored_location_for(resource) || new_trip_path
  end

  protected
  def configure_permitted_parameters

    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:first_name, :last_name, :number, :email, :password, :password_confirmation) }
    devise_parameter_sanitizer.for(:accont_update) { |u| u.permit(:first_name, :last_name, :number, :email, :password, :password_confirmation) }
  end
end
