class ReservationsController < ApplicationController
  before_action :authenticate_user!, only: [:confirm]
  before_action :set_inn_and_room, except: [:validate]

  def new
    @reservation = @room.reservations.build
  end

  def create
    @reservation = @room.reservations.build(reservation_params)
    start = @reservation.start_date.to_date if @reservation.start_date
    finish = @reservation.end_date.to_date if @reservation.end_date
    @reservation.price = @room.calculate_total_price(start, finish)

    if @reservation.save
      redirect_to validate_reservation_path(@reservation)
    else
      flash.now[:notice] = 'Não foi possível seguir com sua reserva'
      render 'new'
    end
  end

  def validate
    @reservation = Reservation.find(params[:id])
    @inn = @reservation.inn
  end

  def confirm
    @reservation = Reservation.find(params[:id])
    @reservation.user = current_user
    @reservation.confirmed!
    @reservation.save
    redirect_to my_reservations_path, notice: 'Sua reserva foi criada com sucesso!'
  end

  private

  def reservation_params
    params.require(:reservation).permit(:start_date, :end_date, :number_guests)
  end

  def set_inn_and_room
    @inn = Inn.find_by(params[:inn_id])
    @room = Room.find_by(params[:room_id])
  end
end