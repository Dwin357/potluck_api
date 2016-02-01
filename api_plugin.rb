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
    load_my_key
  end

  def new_potluck_item(item)
    send_new_item_post(item)
    potluck_items
  end

  def potluck_items
    @potluck_items || fetch_potluck_items
  end

  def ready?
    @ready
  end

  private
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
    parse_get_items_response( Net::HTTP.get_response( make_items_uri ) )
  end

  def send_new_item_post(new_item)
    http    = construct_potluck_http
    request = construct_new_item_request(new_item)
    parse_new_item_api_response(http.request(request))
  end

  def make_items_uri
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

  def construct_new_item_request(new_item)
    api_resource = "/items"
    header       = { "Content-Type" => "application/json" }
    request      = Net::HTTP::Post.new(api_resource, header)

    request.body = { "api_key" => my_key, 
                     "item" => { "name" => new_item }
                     }.to_json

    request
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
      self.ready  = false
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
      self.ready  = false
      self.errors = response['errors']
    end
  end

  def parse_new_item_api_response(api_response)
    if api_response.code == "201"
      fetch_potluck_items
    else
      # no model validations that would cause this to error right now
      self.ready  = false
      self.errors = ["something went wrong"]
    end
  end

  def save_my_key(new_api_key)
    File.open("api_key.txt", "w") { |f| f.write(new_api_key) }
  end

  # def log_response(response)
  #   log_data("\n")
  #   log_data("code:#{response.code} message:#{response.message}")
  #   log_data("body:#{response.body}")
  # end

  # def log_data(data)
  #   File.open("log.txt", "a") { |f| f.puts data }
  # end
end