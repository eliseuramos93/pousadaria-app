class RoomsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :assure_inn_belongs_to_user, except: [:create_new_room, :show]
  before_action :set_inn_and_room, only: [:create]

  def create_new_room
    @inn = current_user.inn
    @room = @inn.rooms.build
    render 'new'
  end

  def create
    if @room.save
      redirect_to [@inn, @room], notice: 'Quarto criado com sucesso'
    else
      flash.now[:notice] = 'Não foi possível criar novo quarto'
      render 'new', status: :unprocessable_entity
    end
  end

  def show
    @inn = Inn.find(params[:inn_id])
    @room = @inn.rooms.where(id: params[:id]).first
  end

  private

  def room_params
    params.require(:room).permit(:name, :description, :area, :max_capacity,
                                 :rent_price, :has_bathroom, :has_balcony,
                                 :has_air_conditioner, :has_tv, :has_wardrobe,
                                 :has_vault, :is_accessible, :status)
  end

  def set_inn_and_room
    @inn = current_user.inn
    @room = @inn.rooms.build(room_params)
  end

  def assure_inn_belongs_to_user
    @inn = Inn.find(params[:inn_id])

    unless current_user == @inn.user
      redirect_to root_path, notice: 'Você não possui autorização para essa ação.'
    end
  end
end