class HomeController < ApplicationController
  before_action :force_inn_creation_for_hosts

  def index 
    @recent_inns = Inn.active.last(3)
    @inns = Inn.active.to_a.difference(@recent_inns)
  end
end