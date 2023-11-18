class ReservationsController < ApplicationController
  before_action :authenticate_user!, only: [:confirm, :cancel, :show] 
  before_action :fetch_inn_and_room, except: [:validate, :confirm, :cancel, 
                                              :show, :host_cancel]
  before_action :fetch_reservation, only: [:validate, :confirm, :cancel]
  before_action :ensure_user_is_regular, only: [:confirm, :cancel]

  def new
    @reservation = @room.reservations.build
  end

  def create
    @reservation = @room.reservations.build(reservation_params)

    if @reservation.save
      redirect_to validate_reservation_path(@reservation)
      session[:reservation_id] = @reservation.id
    else
      flash.now[:notice] = 'Não foi possível seguir com sua reserva'
      render 'new'
    end
  end

  def show
    @reservation = Reservation.find(params[:id])
    @inn = @reservation.inn
  end

  def validate
    @inn = @reservation.room.inn
  end

  def confirm
    @reservation.update(status: 'confirmed', user: current_user)
    session.delete(:reservation_id)
    redirect_to my_reservations_path, 
      notice: 'Sua reserva foi criada com sucesso!'
  end

  def cancel
    if @reservation.guest_cancel_request_with_seven_or_more_days_ahead?
      @reservation.canceled!
      redirect_to my_reservations_path, 
        notice: 'Sua reserva foi cancelada com sucesso!'
    else
      redirect_to my_reservations_path, 
        notice: 'Não é possível cancelar uma reserva a menos de 7 dias do check-in'
    end
  end

  def host_cancel
    @reservation = Reservation.find(params[:id])

    if @reservation.host_allowed_to_cancel?
      @reservation.canceled!
      redirect_to my_inn_reservations_path, 
        notice: 'A reserva foi cancelada com sucesso!'
    else
      redirect_to @reservation, alert: 'Não é possível cancelar a reserva com menos de 3 dias de atraso.'
    end
  end

  private

  def reservation_params
    params.require(:reservation).permit(:start_date, :end_date, :number_guests)
  end

  private 

  def fetch_reservation
    @reservation = Reservation.find(params[:id])
  end

  def fetch_inn_and_room
    @inn = Inn.find(params[:inn_id])
    @room = Room.find(params[:room_id])
  end

  def ensure_user_is_regular
    unless user_signed_in? && current_user.regular?
      redirect_to root_path, 
        alert: 'Você não possui autorização para acessar essa página'
    end
  end
end