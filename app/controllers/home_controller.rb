class HomeController < ApplicationController
  before_action :force_inn_creation_for_hosts

  def index 
  end
end