class RoomsController < ApplicationController
  before_action :authenticate_user!, only: [:create_new_room, :create, :edit,
                                            :update]
  before_action :redirect_inexistent_inn_id, except: [:create_new_room]
  before_action :ensure_user_owns_inn, only: [:create, :edit,
                                              :update]
  before_action :find_inn_and_build_room, only: [:create]

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

    if @room.inactive?
      redirect_to root_path, notice: 'Este quarto não está disponível no momento.'
    end
  end

  def edit
    @inn = Inn.find(params[:inn_id])
    @room = @inn.rooms.where(id: params[:id]).first
  end

  def update
    @inn = Inn.find(params[:inn_id])
    @room = @inn.rooms.where(id: params[:id]).first

    if @room.update(room_params)
      redirect_to [@inn, @room], notice: 'Quarto atualizado com sucesso'
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

  def redirect_inexistent_inn_id
    unless Inn.where(id: params[:inn_id]).exists?
      redirect_to root_path, notice: 'Essa página não existe'
    end
  end

  def find_inn_and_build_room
    @inn = current_user.inn
    @room = @inn.rooms.build(room_params)
  end

  def ensure_user_owns_inn
    @inn = Inn.find(params[:inn_id])

    unless current_user.host? && current_user == @inn.user
      redirect_to root_path, notice: 'Você não possui autorização para essa ação.'
    end
  end
end