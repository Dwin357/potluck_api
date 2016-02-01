require "net/http"
require "uri"
require "json"

class ApiPlugin
  attr_reader :potluck_items, :errors
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

  def ready?
    @ready
  end

  private
  attr_accessor :my_key
  attr_writer :ready, :errors

  def has_api_key?
    !File.zero?("api_key.txt")
  end

  def load_my_key
    if has_api_key?
      my_key = File.open("api_key.txt", "r") { |f| f.read }
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

  def log_data(data)
    File.open("log.txt", "a") { |f| f.puts data }
  end

  def save_my_key(new_api_key)
    File.open("api_key.txt", "w") { |f| f.write(new_api_key) }
  end


end

tst = ApiPlugin.new
# puts tst.has_api_key?
# tst.fetch_new_api_key_for("test4@email.com")
# p tst.errors
tst.new_user("test5@email.com")
puts tst.ready?