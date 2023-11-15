class CheckoutsController < ApplicationController
  before_action :authenticate_user!

  def new
    @reservation = Reservation.find(params[:reservation_id])
    @checkout = @reservation.build_checkout
  end

  def create
    @reservation = Reservation.find(params[:reservation_id])
    @checkout = @reservation.build_checkout(checkout_params)

    if @checkout.save
      new_price = @reservation.room.calculate_checkout_price(@reservation)
      @reservation.update(end_date: Date.today, status: 'finished', 
                          price: new_price)

      redirect_to my_inn_reservations_path, 
        notice: 'Check-out registrado com sucesso!'
    end
  end

  private

  def checkout_params
    params.require(:checkout).permit(:payment_method)
  end
end