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
end