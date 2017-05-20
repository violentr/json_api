class WelcomeController < ApplicationController

  def index
    if request.post?
      base_url =  APPCONFIG["api"]["base_url"]
      auth = {"name" => "", "password" => ""}.merge!(user_params.to_h)
      user_credentials =
        {
            "api_user": {
            "email": APPCONFIG["api"]["user"]["email"],
            "password": APPCONFIG["api"]["user"]["password"]
             }

        }.to_json
      headers = {accept: "application/json", content_type: "application/json"}
    conn = Faraday.new(url: base_url, headers: headers) do |faraday|
        faraday.basic_auth(*auth.values)
        faraday.request :json
        faraday.response :json, content_type: "application/json"
        faraday.adapter Faraday.default_adapter
      end
      response = conn.post('api/sessions', user_credentials)

      render json: {message: response.body}
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :password)
  end
end
