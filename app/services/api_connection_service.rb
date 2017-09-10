class ApiConnectionService
  attr_reader :user_params

  BASE_URL = APPCONFIG["api"]["base_url"]

  def initialize(user_params)
    @user_params = user_params
  end

  def connect
    begin
      Faraday.new(url: BASE_URL, headers: headers) do |faraday|
        faraday.basic_auth(*user_params.values)
        faraday.request :json
        faraday.response :json, content_type: "application/json"
        faraday.adapter Faraday.default_adapter
      end
    rescue
      error
    end
  end

  def auth_hash
    response = connect.post(BASE_URL + 'api/sessions', api_user_credentials)
    error unless response.status == 201
    email = response.body["data"]["attributes"]["key"]
    token = response.body["data"]["attributes"]["token"]
    headers.merge!({"X-USER-TOKEN" => token, "X-USER-EMAIL"=> email})
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

  def error
    raise ApiConnectionServiceError.new("Some API settings are missing")
  end

end


class ApiConnectionServiceError < StandardError; end
