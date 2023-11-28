class ConsumablesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :redirect_invalid_reservation, only: [:new, :create]
  before_action :redirect_if_reservation_is_not_active, only: [:new, :create]
  before_action :ensure_user_owns_inn, only: [:new, :create]

  def new
    @consumable = @reservation.consumables.build
  end

  def create
    @consumable = @reservation.consumables.build(consumable_params)

    if @consumable.save
      redirect_to reservation_path(@reservation), 
        notice: 'O consumo foi registrado com sucesso'
    else
      flash.now[:notice] = 'O consumo não pôde ser registrado'
      render 'new'
    end
  end

  private

  def consumable_params
    params.require(:consumable).permit(:description, :price)
  end

  def redirect_invalid_reservation
    @reservation = Reservation.find_by(id: params[:reservation_id])

    if @reservation.blank?
      redirect_to root_path, alert: 'Essa página não existe'
    end
  end

  def ensure_user_owns_inn
    @inn = @reservation.inn

    unless current_user == @inn.user
      redirect_to root_path, alert: 'Você não possui autorização para essa ação'
    end
  end

  def redirect_if_reservation_is_not_active
    unless @reservation.active?
      redirect_to reservation_path(@reservation),
        alert: 'Não é possível registrar consumo em uma reserva que não está ativa'
    end
  end
end