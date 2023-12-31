class CheckinsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_valid_checkin
  before_action :ensure_user_owns_inn

  def new
    @checkin = @reservation.build_checkin
    @reservation.number_guests.times { @checkin.guests.build }
  end

  def create
    @checkin = @reservation.build_checkin(checkin_params)

    if @checkin.save
      @reservation.active!
      redirect_to my_inn_reservations_path, notice: 'Check-in registrado com sucesso!'
    else
      flash.now[:notice] = 'Não foi possível confirmar o checkin'
      render 'new'
    end
  end

  private

  def checkin_params
    params.require(:checkin).permit(guests_attributes: [:full_name, :document])
  end

  def ensure_valid_checkin
    @reservation = Reservation.find(params[:reservation_id])

    unless @reservation.checkin_within_business_rules?
      start_date = @reservation.start_date.to_date
      redirect_to my_inn_reservations_path, notice: "Não é possível realizar check-in nessa reserva"
    end
  end

  def ensure_user_owns_inn
    @inn = @reservation.inn

    if current_user != @inn.user
      redirect_to root_path, alert: 'Você não possui autorização para essa ação.'
    end
  end

end