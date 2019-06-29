class ApplicationController < ActionController::API
  def index
    render json: {ok: true}
  end
end
