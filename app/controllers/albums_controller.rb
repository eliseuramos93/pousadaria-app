class AlbumsController < ApplicationController
  before_action :authenticate_user!, only: [:new_inn_pictures, :create]
  before_action :ensure_user_is_host, only: [:new_inn_pictures, :create]

  def new_inn_pictures
    @inn = current_user.inn
    @album = @inn.build_album
  end

  def create
    @inn = current_user.inn
    @album = @inn.build_album(album_params)

    if @album.save
      redirect_to inn_path(@inn), notice: 'Suas fotos foram adicionadas com sucesso!'
    end
  end

  private

  def album_params
    params.require(:album).permit(photos: [])
  end
end