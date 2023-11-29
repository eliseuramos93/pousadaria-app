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

    inn_json = inn.generate_show_inn_json

    render status: 200, json: inn_json
  end

  def city_list
    cities = Inn.active.joins(:address).select('city').order(:city)
    
    cities_array = cities.reduce([]) { |array, object| array << object.city }
    
    render status: 200, json: cities_array.as_json
  end
end