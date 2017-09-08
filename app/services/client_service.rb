class ClientService
  attr_reader :connection

  def initialize(auth_hash)
    @connection = Faraday.new(url: url, headers: auth_hash)
  end

  def list
    response = connection.get(url + 'api/clients')
    JSON.parse(response.body)["data"]
  end

  def url
    ApiConnectionService::BASE_URL
  end

end
