class SeasonalRatesController < ApplicationController
  before_action :authenticate_user!
  before_action :force_inn_creation_for_hosts
  before_action :redirect_invalid_inn_or_room
  before_action :ensure_user_owns_inn

  def new
    @seasonal_rate = @room.seasonal_rates.build
  end

  def create
    @seasonal_rate = @room.seasonal_rates.build(seasonal_rate_params)

    if @seasonal_rate.save
      redirect_to [@inn, @room], notice: 'Preço de Temporada criado com sucesso'
    else
      flash.now[:notice] = 'Não foi possível criar novo preço de temporada'
      render 'new'
    end
  end

  private

  def seasonal_rate_params
    params.require(:seasonal_rate).permit(:start_date, :end_date, :price)
  end

  def redirect_invalid_inn_or_room
    @inn = Inn.find_by(id: params[:inn_id])
    @room = @inn.rooms.find_by(id: params[:room_id])

    if @inn.nil? || @room.nil?
      redirect_to root_path, notice: 'Essa página não existe'
    end
  end

  def ensure_user_owns_inn
    unless current_user.host? && current_user == @inn.user
      redirect_to root_path, notice: 'Você não possui autorização para essa ação.'
    end
  end
end