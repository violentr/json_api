class ApiConnectionService
  attr_reader :url, :user_params

  def initialize(user_params)
    @url = APPCONFIG["api"]["base_url"]
    @user_params = user_params
  end

  def connect
    begin
      Faraday.new(url: url, headers: headers) do |faraday|
        faraday.basic_auth(*user_params.values)
        faraday.request :json
        faraday.response :json, content_type: "application/json"
        faraday.adapter Faraday.default_adapter
      end
    rescue
      raise ApiConnectionServiceError.new "Your API url is missing"
    end
  end

  def login
    connect.post('api/sessions', api_user_credentials)
  end

  private

  def api_user_credentials
    {
      "api_user": {
        "email": APPCONFIG["api"]["user"]["email"],
        "password": APPCONFIG["api"]["user"]["password"]
      }
    }
  end

  def headers
    {accept: "application/json", content_type: "application/json"}
  end

end


class ApiConnectionServiceError < StandardError; end
