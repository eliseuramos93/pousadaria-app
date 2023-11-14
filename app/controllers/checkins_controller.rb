class CheckinsController < ApplicationController
  before_action :authenticate_user!
  before_action :available_for_checkin, only: [:new]

  def new
  end

  private

  def available_for_checkin
    @reservation = Reservation.find(params[:reservation_id])

    if @reservation.early_for_checkin
      start_date = @reservation.start_date.to_date
      redirect_to my_inn_reservations_path, notice: "Check-in só pode ser feito a partir de #{I18n.l(start_date)}"
    end
  end
end