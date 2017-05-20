class WelcomeController < ApplicationController

  def index
    if request.post?
      api_server = ApiConnectionService.new(user_params.to_h)
      api_server.connect
      response = api_server.login
      render json: {message: response.body}
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :password)
  end
end
