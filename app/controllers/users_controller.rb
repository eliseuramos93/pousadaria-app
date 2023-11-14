class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_user_is_regular

  def my_reservations
    @user = current_user
    @reservations = @user.reservations
  end

  private

  def ensure_user_is_regular
    unless user_signed_in? && current_user.regular?
      redirect_to root_path, alert: 'Você não possui autorização para acessar essa página'
    end
  end
end
