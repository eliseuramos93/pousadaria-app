class PhotosController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_user_is_host

  def destroy
    @inn = current_user.inn
    @photo = @inn.album.photos.find(params[:id])

    @photo.destroy

    redirect_to inn_path(@inn), notice: 'Sua foto foi deletada com sucesso'
  end
end
