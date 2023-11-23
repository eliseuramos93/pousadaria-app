class Api::V1::ApiController < ActionController::API
  rescue_from ActiveRecord::ActiveRecordError, with: :return_server_error
  private

  def return_server_error
    render status: 500, json: { errors: 'Ops, tivemos um erro no servidor.' }
  end
end