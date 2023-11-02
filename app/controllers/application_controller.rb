class ApplicationController < ActionController::Base
  private

  def force_inn_creation_for_owners
    if user_signed_in? && current_user.inn.nil?
      return redirect_to new_inn_path, alert: 'É necessário cadastrar uma pousada para continuar.'
    end
  end
end
