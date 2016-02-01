require "net/http"
require "uri"
require "json"

class ApiPlugin
  attr_reader :errors
  def initialize
    @my_key
    @potluck_items
    @ready
    @errors

    load_my_key
  end

  def new_user(user_email)
    fetch_new_api_key_for(user_email)
    return errors if errors
    load_my_key
  end

  def potluck_items
    @potluck_items || fetch_potluck_items
  end

  def ready?
    @ready
  end

  # private
  attr_accessor :my_key
  attr_writer :ready, :errors, :potluck_items

  def has_api_key?
    !File.zero?("api_key.txt")
  end

  def load_my_key
    if has_api_key?
      self.my_key = File.open("api_key.txt", "r") { |f| f.read }
      self.ready = true
    else
      self.ready = false
    end
  end

  def fetch_new_api_key_for(user_email)
    http    = construct_potluck_http
    request = construct_new_user_request(user_email)
    parse_user_api_response(http.request(request))
  end

  def fetch_potluck_items
    parse_get_items_response(
      Net::HTTP.get_response(
        get_items_uri
      )
    )
  end

  def get_items_uri
    uri       = URI("https://potluck-api.herokuapp.com")
    uri.path  = "/items"
    uri.query = "api_key="+my_key
    uri
  end

  def construct_potluck_http
    uri = URI.parse("https://potluck-api.herokuapp.com")
    potluck_http = Net::HTTP.new(uri.host, uri.port)
    potluck_http.use_ssl = true
    potluck_http
  end

  def construct_new_user_request(user_email)
    api_resource = "/users"
    header       = { "Content-Type" => "application/json" }
    request      = Net::HTTP::Post.new(api_resource, header)

    request.body = { "user"=> { "email" => user_email } }.to_json
    
    request
  end

  def parse_user_api_response(api_response)
    response_hash = JSON.parse(api_response.body)
    if api_response.code == "201"
      save_my_key(response_hash['api_key'])
    else
      self.errors = response_hash['email']
    end
  end

  def parse_get_items_response(api_response)
    response = JSON.parse(api_response.body)

    if api_response.code == "200"
      self.potluck_items = response.map do |item|
        item["name"] + " brought by " + item["user_id"].to_s
      end
    else
      self.errors = response['errors']
    end
  end

  def log_data(data)
    File.open("log.txt", "a") { |f| f.puts data }
  end

  def save_my_key(new_api_key)
    File.open("api_key.txt", "w") { |f| f.write(new_api_key) }
  end


end

tst = ApiPlugin.new
# puts tst.my_key
# puts tst.has_api_key?
# tst.fetch_new_api_key_for("test4@email.com")
# p tst.errors
puts tst.potluck_items
# puts tst.ready?