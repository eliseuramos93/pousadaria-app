class Api::V1::ApiController < ActionController::API
  rescue_from ActiveRecord::ActiveRecordError, with: :return_server_error
  rescue_from ActiveRecord::RecordNotFound, with: :return_not_found

  private

  def return_server_error
    render status: 500, json: { errors: 'Ops, tivemos um erro no servidor.' }
  end

  def return_not_found
    render status: 404, json: { errors: 'O id informado não foi encontrado.' }
  end
end