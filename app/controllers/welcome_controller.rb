class WelcomeController < ApplicationController

  def index
    if request.post?
      api_server = ApiConnectionService.new(user_params.to_h)
      api_server.connect
      clients = ClientService.new(api_server.auth_hash).list
      render json: {message: clients}
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :password)
  end
end
