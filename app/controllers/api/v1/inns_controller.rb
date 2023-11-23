class Api::V1::InnsController < Api::V1::ApiController

  def index
    if params[:name]
      inns = Inn.active.where("brand_name LIKE ?", "%#{params[:name]}%")
    else
      inns = Inn.active
    end

    render status: 200, 
      json: inns.as_json(except: [:status, :created_at, :updated_at, :user_id], 
                          include: {
                            address: {
                              except: [:id, :inn_id, :created_at, :updated_at]
                            }
                          })
  end

  def show
    inn = Inn.find(params[:id])

    inn_json = generate_show_inn_json(inn)

    render status: 200, json: inn_json
  end

  private

  def generate_show_inn_json(inn)
    average_rating = generate_average_rating(inn)

    inn_json = inn.as_json(
      include: { 
        address: { 
          except: [:id, :inn_id, :created_at, :updated_at]}},
      except: [:created_at, :updated_at, :user_id, :registration_number])

    inn_json.merge!(average_rating: average_rating)
  end

  def generate_average_rating(inn)
    return '' if inn.average_rating.blank?

    inn.average_rating.to_f
  end
end