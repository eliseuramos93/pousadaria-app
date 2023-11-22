class SeasonalRatesController < ApplicationController
  before_action :authenticate_user!
  before_action :force_inn_creation_for_hosts
  before_action :redirect_invalid_inn_or_room, only: [:index, :create, :new]
  before_action :redirect_invalid_seasonal_rate, only: [:edit, :update]
  before_action :ensure_user_owns_inn
  before_action :block_past_seasonal_rates_alteration, only: [:edit, :update]

  def index
    @seasonal_rates = @room.seasonal_rates
  end

  def new
    @seasonal_rate = @room.seasonal_rates.build
  end

  def create
    @seasonal_rate = @room.seasonal_rates.build(seasonal_rate_params)

    if @seasonal_rate.save
      redirect_to room_path(@room), notice: 'Preço de Temporada criado com sucesso'
    else
      flash.now[:notice] = 'Não foi possível criar novo preço de temporada'
      render 'new'
    end
  end

  def edit; end

  def update
    if @seasonal_rate.update(seasonal_rate_params)
      redirect_to room_seasonal_rates_path(@room), 
        notice: 'Seu preço de temporada foi atualizado com sucesso'
    else
      flash.now[:notice] = 'Não foi possível atualizar seu preço de temporada'
      render 'edit'
    end
  end

  private

  def seasonal_rate_params
    params.require(:seasonal_rate).permit(:start_date, :end_date, :price)
  end

  def redirect_invalid_inn_or_room
    @room = Room.find_by(id: params[:room_id])

    if @room.nil?
      redirect_to root_path, notice: 'Essa página não existe'
    else
      @inn = @room.inn
    end
  end

  def redirect_invalid_seasonal_rate
    @seasonal_rate = SeasonalRate.find_by(id: params[:id])

    if @seasonal_rate.nil?
      redirect_to root_path, notice: 'Essa página não existe'
    else
      @room = @seasonal_rate.room
      @inn = @room.inn
    end
  end

  def ensure_user_owns_inn
    unless current_user.host? && current_user == @inn.user
      redirect_to root_path, notice: 'Você não possui autorização para essa ação.'
    end
  end

  def block_past_seasonal_rates_alteration
    if @seasonal_rate.start_date.past?
      redirect_to room_seasonal_rates_path(@room),
        notice: 'Não é possível alterar um preço de temporada que já iniciou'
    end
  end
end