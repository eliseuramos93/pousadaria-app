class ReservationsController < ApplicationController

  def new
    @room = Room.find_by(params[:room_id])
    @inn = Inn.find_by(params[:inn_id])
    @reservation = @room.reservations.build
  end

  def create
    @inn = Inn.find_by(params[:inn_id])
    @room = Room.find_by(params[:room_id])
    @reservation = @room.reservations.build(reservation_params)
    start = @reservation.start_date.to_date if @reservation.start_date
    finish = @reservation.end_date.to_date if @reservation.end_date
    @reservation.price = @room.calculate_total_price(start, finish)

    if @reservation.save
      redirect_to confirm_reservation_path(@reservation)
    else
      flash.now[:notice] = 'Não foi possível seguir com sua reserva'
      render 'new'
    end
  end

  def confirm
    @reservation = Reservation.find(params[:id])
  end

  private

  def reservation_params
    params.require(:reservation).permit(:start_date, :end_date, :number_guests)
  end
end