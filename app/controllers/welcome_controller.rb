class WelcomeController < ApplicationController

  def index
  end

  def clients
    api_server = ApiConnectionService.new(user_params.to_h)
    api_server.connect
    @clients = ClientService.new(api_server.auth_hash).list
  end

  private

  def user_params
    params.require(:user).permit(:name, :password)
  end
end
