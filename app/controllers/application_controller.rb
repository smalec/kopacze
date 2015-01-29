class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_position_name

protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name << :surname << :position << :town_id
    devise_parameter_sanitizer.for(:account_update) << :name << :surname << :position << :town_id
  end

  def set_position_name
    @position_name = {'gk'  => 'Bramkarz',
                      'def' => 'Obrońca',
                      'mid' => 'Pomocnik',
                      'for' => 'Napastnik'}
  end
end
