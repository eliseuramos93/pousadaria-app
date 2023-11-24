class Api::V1::RoomsController < Api::V1::ApiController
  
  def index
    inn = Inn.find(params[:inn_id])
    rooms = inn.rooms.active

    render status: 200, json: rooms.as_json(except: [:created_at, :updated_at])
  end

  def check_availability
    room = Room.find(params[:id])
    reservation = room.reservations.build(reservation_params)
    if reservation.save
      render status: 200, json: reservation.as_json(except: [:user_id, :room_id, :status,
                                                           :created_at, :updated_at])
    else
      errors_json = { errors: reservation.errors.full_messages }
      render status: 200, json: errors_json.as_json
    end
  end

  private

  def reservation_params
    params.permit(:start_date, :end_date, :number_guests)
  end
end