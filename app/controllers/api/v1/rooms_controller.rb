class Api::V1::RoomsController < Api::V1::ApiController
  
  def index
    inn = Inn.find(params[:inn_id])
    rooms = inn.rooms.active

    render status: 200, json: rooms.as_json(except: [:created_at, :updated_at])
  end
end