class Api::V1::RoomsController < Api::V1::ApiController
  rescue_from ActiveRecord::RecordNotFound, with: :return_inn_not_found
  
  def index
    inn = Inn.find(params[:inn_id])
    rooms = inn.rooms.active

    render status: 200, json: rooms.as_json(except: [:created_at, :updated_at])
  end

  private

  def return_inn_not_found
    render status: 404, json: { errors: 'Não existe pousada com esse id.' }
  end
end