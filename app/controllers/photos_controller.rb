class PhotosController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_user_is_host
  before_action :fetch_instance_variables

  def destroy
    @photo.destroy

    if @album.imageable_type == 'Inn'
      @inn = @album.imageable
      redirect_to inn_path(@inn), notice: 'Sua foto foi deletada com sucesso'
    elsif @album.imageable_type == 'Room'
      @room = @album.imageable
      redirect_to room_path(@room), notice: 'Sua foto foi deletada com sucesso'
    end
  end

  private

  def fetch_instance_variables
    @album = Album.find(params[:album_id])
    @photo = @album.photos.find(params[:id])
  end
end
