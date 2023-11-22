class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_instance_variables, only: [:new, :create]
  before_action :redirect_invalid_user_for_reservation, only: [:new, :create]
  before_action :redirect_invalid_new_review_attempt, only: [:new, :create]
  
  def new
    @review = @reservation.build_review
  end

  def create
    @review = @reservation.build_review(review_params)

    if @review.save
      redirect_to @reservation, notice: 'Sua avaliação foi criada com sucesso'
    else
      flash.now[:notice] = 'Não foi possível criar sua avaliação'
      render 'new'
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :comment)
  end

  def set_instance_variables
    @reservation = Reservation.find_by(params[:reservation_id])
    if @reservation.present?
      @room = @reservation.room
      @inn = @reservation.inn
    end
  end

  def redirect_invalid_user_for_reservation
    if @reservation.user != current_user
      redirect_to root_path, alert: 'Você não possui autorização para essa ação.'
    end
  end

  def redirect_invalid_new_review_attempt
    unless @reservation.able_to_be_reviewed?
      redirect_to @reservation, alert: 'Você não pode criar uma nova avaliação para essa estadia.'
    end
  end
end