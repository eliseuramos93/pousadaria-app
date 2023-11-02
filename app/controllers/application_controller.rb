class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:role])
  end

  private

  def force_inn_creation_for_hosts
    if user_signed_in? && current_user.inn.nil? && current_user.host?
      return redirect_to new_inn_path, alert: 'É necessário cadastrar uma pousada para continuar.'
    end
  end
end
