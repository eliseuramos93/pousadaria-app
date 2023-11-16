class HomeController < ApplicationController
  before_action :force_inn_creation_for_hosts

  def index 
    if user_signed_in? && session[:reservation_id]
      redirect_to validate_reservation_path(session[:reservation_id])
    end

    @recent_inns = Inn.active.last(3)
    @inns = Inn.active.to_a.difference(@recent_inns)
    @locations = Address.select(:city).distinct
  end
end