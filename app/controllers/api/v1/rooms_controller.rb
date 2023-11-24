class Api::V1::RoomsController < Api::V1::ApiController
  
  def index
    inn = Inn.find(params[:inn_id])
    rooms = inn.rooms.active

    render status: 200, json: rooms.as_json(except: [:created_at, :updated_at])
  end

  def check_availability
    room = Room.find(params[:id])
    reservation = room.reservations.build(start_date: params['reservation']['start_date'],
                                            end_date: params['reservation']['end_date'],
                                            number_guests: params['reservation']['number_guests'])
    if reservation.save
      render status: 200, json: reservation.as_json(except: [:user_id, :room_id, :status,
                                                           :created_at, :updated_at])
    else
      errors_json = { errors: reservation.errors.full_messages }
      render status: 200, json: errors_json.as_json
    end
  end
end