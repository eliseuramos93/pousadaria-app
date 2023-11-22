class HostRepliesController < ApplicationController
  before_action :authenticate_user!
  
  def new
    @review = Review.find(params[:review_id])
    @reservation = @review.reservation
    @room = @reservation.room
    @host_reply = @review.build_host_reply
  end

  def create
    @review = Review.find(params[:review_id])
    @reservation = @review.reservation
    @room = @reservation.room
    @host_reply = @review.build_host_reply(host_reply_params)

    if @host_reply.save
      redirect_to my_inn_reviews_path, notice: 'Sua resposta foi criada com sucesso'
    end
  end

  private

  def host_reply_params
    params.require(:host_reply).permit(:text)
  end
end