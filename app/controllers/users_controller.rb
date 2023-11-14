class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:my_reservations]

  def my_reservations
    @user = current_user
    @reservations = @user.reservations
  end
end
