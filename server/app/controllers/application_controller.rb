class ApplicationController < ActionController::API
  def index
    p = Project.all
    render json: p
  end
end
