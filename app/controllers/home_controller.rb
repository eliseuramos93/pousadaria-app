class HomeController < ApplicationController
  before_action :force_inn_creation_for_owners

  def index 
  end
end