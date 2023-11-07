class InnsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :city_list, :search]
  before_action :force_inn_creation_for_hosts, except: [:new, :create, 
                                                        :city_list, :search]
  before_action :ensure_inn_exists, except: [:new, :create, :my_inn, :city_list, 
                                            :search]
  before_action :ensure_user_is_host, except: [:show, :my_inn, :city_list, 
                                              :search]
  before_action :ensure_user_owns_inn, except: [:new, :create, :my_inn, :show, 
                                                :city_list, :search]
  before_action :fetch_address_and_payment_methods, only: [:edit, :update]

  def new
    @inn = Inn.new
    @address = @inn.build_address
    @payment_method = @inn.build_payment_method 
  end

  def create
    @inn = current_user.build_inn(inn_params)
    @address = @inn.build_address(address_params)
    @payment_method = @inn.build_payment_method(payment_method_params)

    if @inn.save
      redirect_to @inn, notice: 'Sua pousada foi registrada com sucesso!'
    else
      flash.now[:notice] = 'Não foi possível concluir o registro da sua pousada.'
      render 'new', status: :unprocessable_entity
    end
  end

  def show 
    if current_user != @inn.user && @inn.inactive?
      redirect_to root_path, alert: 'A página não está disponível'
    end
  end

  def edit; end

  def update
    @address.update(address_params)
    @payment_method.update(payment_method_params) unless payment_method_params.nil?

    if @inn.update(inn_params)
      redirect_to @inn, notice: 'Sua pousada foi atualizada com sucesso.'
    else
      flash.now[:notice] = 'Não foi possível atualizar sua pousada.'
      render 'edit', status: :unprocessable_entity
    end
  end

  def my_inn
    @inn = current_user.inn
    render 'show'
  end
  
  def inactive
    @inn.inactive!
    redirect_to @inn
  end

  def active
    @inn.active!
    redirect_to @inn
  end

  def city_list
    @inns = Inn.active.joins(:address).where('city LIKE ?', params[:city]).order(:brand_name)
  end

  def search
    @query = params[:query]
    sql = 'city LIKE ? OR neighborhood LIKE ? OR brand_name LIKE ?'
    @inns = Inn.active.joins(:address).where(sql, "%#{@query}%", "%#{@query}%", "%#{@query}%")
  end

  private

  def address_params
    params.require(:address).permit(:street_name, :number, :complement, 
                                    :neighborhood, :city, :state, :zip_code)
  end

  def inn_params
    params.require(:inn).permit(:brand_name, :registration_number, :phone_number,
                                :description, :policy, :pet_friendly, 
                                :checkin_time, :checkout_time)
  end

  def payment_method_params
    if params[:payment_method].present?
      params.require(:payment_method).permit(:bank_transfer, :credit_card, 
                                            :debit_card, :cash, :deposit)
    end
  end

  def ensure_inn_exists
    @inn = Inn.find_by(id: params[:id])

    if @inn.nil?
      redirect_to root_path, alert: 'Essa página não existe'
    end
  end

  def ensure_user_owns_inn
    if @inn.user != current_user
      redirect_to root_path, alert: 'Você não possui autorização para essa ação.'
    end
  end

  def ensure_user_is_host
    unless current_user.host? 
      redirect_to root_path, alert: 'Você não possui autorização para essa ação.'
    end
  end

  def fetch_address_and_payment_methods
    @address = @inn.address
    @payment_method = @inn.payment_method
  end
end