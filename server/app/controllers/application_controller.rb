class ApplicationController < ActionController::API
  def index
    render json: Project.all.as_json(include: [:id])
  end
end
