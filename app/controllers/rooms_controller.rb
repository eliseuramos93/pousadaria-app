class RoomsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :new, :create, :edit, :update]
  before_action :force_inn_creation_for_hosts
  before_action :redirect_invalid_inn, only: [:index, :create]
  before_action :redirect_invalid_room, only: [:show, :edit, :update]
  before_action :ensure_user_owns_inn, only: [:index, :create, :edit, :update]
  before_action :ensure_room_belongs_to_inn, only: [:edit, :update]

  def index
    @rooms = @inn.rooms
  end

  def new
    @inn = current_user.inn
    @room = @inn.rooms.build
  end

  def create
    @room = @inn.rooms.build(room_params)

    if @room.save
      redirect_to @room, notice: 'Quarto criado com sucesso'
    else
      flash.now[:notice] = 'Não foi possível criar novo quarto'
      render 'new', status: :unprocessable_entity
    end
  end

  def show
    if @room.inactive? && @inn.user != current_user
      redirect_to root_path, notice: 'Este quarto não está disponível no momento.'
    end
  end

  def edit; end

  def update
    if @room.update(room_params)
      redirect_to @room, notice: 'Quarto atualizado com sucesso'
    else
      flash.now[:notice] = 'Não foi possível atualizar o quarto'
      render 'edit', status: :unprocessable_entity
    end
  end

  private

  def room_params
    params.require(:room).permit(:name, :description, :area, :max_capacity,
                                 :rent_price, :has_bathroom, :has_balcony,
                                 :has_air_conditioner, :has_tv, :has_wardrobe,
                                 :has_vault, :is_accessible, :status)
  end

  def redirect_invalid_inn
    @inn = Inn.find_by(id: params[:inn_id])

    if @inn.nil?
      redirect_to root_path, alert: 'Essa página não existe'
    end
  end

  def ensure_user_owns_inn
    unless current_user.host? && current_user == @inn.user
      redirect_to root_path, alert: 'Você não possui autorização para essa ação.'
    end
  end

  def redirect_invalid_room
    @room = Room.find_by(params[:id])

    if @room.nil?
      redirect_to root_path, alert: 'Essa página não existe'
    else
      @inn = @room.inn
    end
  end

  def ensure_room_belongs_to_inn
    unless @inn.rooms.exists?(id: @room.id)
      redirect_to root_path, alert: 'Essa página não existe' 
    end
  end
end
