class AlbumsController < ApplicationController
  before_action :authenticate_user!, only: [:new_inn_pictures, :new, :create]
  before_action :ensure_user_is_host, only: [:new_inn_pictures, :new, :create]
  before_action :redirect_invalid_room, only: [:new]
  before_action :ensure_user_owns_inn, only: [:new]
  before_action :build_album, only: [:create]

  def new
    @album = @room.build_album
  end

  def new_inn_pictures
    @inn = current_user.inn
    @album = @inn.build_album
  end

  def create
    if @album.imageable_type == 'Inn' && @album.save 
      redirect_to inn_path(@inn), notice: 'Suas fotos foram adicionadas com sucesso!'
    elsif @album.imageable_type == 'Room' && @album.save
      redirect_to room_path(@room), notice: 'Suas fotos foram adicionadas com sucesso!'
    end
  end

  private

  def album_params
    params.require(:album).permit(photos: [])
  end

  def ensure_user_owns_inn
    @inn = @room.inn

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

  def build_album
    if params[:room_id]
      @room = Room.find(params[:room_id])
      @album = @room.build_album(album_params)
    elsif params[:inn_id]
      @inn = Inn.find(params[:inn_id])
      @album = @inn.build_album(album_params)
    end
  end
end