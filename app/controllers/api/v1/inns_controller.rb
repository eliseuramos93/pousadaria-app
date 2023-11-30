class Api::V1::InnsController < Api::V1::ApiController

  def index
    inns = Inn.active
    inns = inns.where("brand_name LIKE ?", "%#{params[:name]}%") if params[:name]
    inns = inns.joins(:address).where("city LIKE ?", "%#{params[:city]}%") if params[:city]

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
    cities = Inn.active.joins(:address).select('city').order(:city).distinct
    
    cities_array = cities.reduce([]) { |array, object| array << object.city }
    
    render status: 200, json: cities_array.as_json
  end
end