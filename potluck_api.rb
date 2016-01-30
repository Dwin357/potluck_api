# possible alternate solution :: https://www.hurl.it/

#######  release 0 ###########
# post to  https://potluck-api.herokuapp.com/users
# data of post { user: { email: <%= insert email here %> } }
# capture response (will have an api_key)

require "net/http"
require "uri"
require "json"

# uri = URI.parse("https://potluck-api.herokuapp.com")
# http = Net::HTTP.new(uri.host, uri.port)
# http.use_ssl = true 

# restful_resource = "/users"
# content = {"user" => {"email"=>"e.r.steinmetz@gmail.com"}}.to_json
# init_header = {"Content-Type" => 'application/json'}

# req = Net::HTTP::Post.new(restful_resource, init_header)
# req.body = content

# response = http.request(req)
# open('test.txt', 'w') do |f|
#   f << "code:#{response.code} message:#{response.message}\n"
#   f << response.body
#   f << "\n\n"
# end

### success!!!!, my_key = 55ab22998f5bae17c3ac49ef0a74eea1

########  release 1 ##########
# get request to  https://potluck-api.herokuapp.com/items?my_key
# or 
# get request to  https://potluck-api.herokuapp.com/items?api_key=my_key
# capture response, the list of items already being brought

# uri = URI.parse("https://potluck-api.herokuapp.com")
# uri = URI("https://potluck-api.herokuapp.com")
# uri.path = "/items"
# uri.query = "api_key=55ab22998f5bae17c3ac49ef0a74eea1"

# response = Net::HTTP.get_response(uri)

# open('test.txt', 'w') do |f|
#   f << "code:#{response.code} message:#{response.message}\n"
#   f << response.body
#   f << "\n\n"
# end

### !!! success: green jello, fish tacos, lumpia, napkins, hungerian gouhlash
### needs some chicken tika masala


##########  release 2 ##########
# post to https://potluck-api.herokuapp.com/items
# data of post { api_key: my_key, item: { name: my_item } }
# get request again to confirm my_item has been added

# uri = URI.parse("https://potluck-api.herokuapp.com")
# http = Net::HTTP.new(uri.host, uri.port)
# http.use_ssl = true

# restful_resource = "/items"
# init_header = {"Content-Type" => 'application/json'}

# content = {"api_key" => "55ab22998f5bae17c3ac49ef0a74eea1",
#            "item" => {
#               "name" => "Chicken Tika Masala"
#             }
#           }.to_json


# req = Net::HTTP::Post.new(restful_resource, init_header)
# req.body = content
# response1 = http.request(req)

# uri.path = "/items"
# uri.query = "api_key=55ab22998f5bae17c3ac49ef0a74eea1"
# response2 = Net::HTTP.get_response(uri)

# open('test.txt', 'w') do |f|
  # f << "code:#{response1.code} message:#{response1.message}\n"
  # f << response1.body
  # f << "\n\n"
#   f << "code:#{response2.code} message:#{response2.message}\n"
#   f << response2.body  
# end


# uri = URI.parse("https://potluck-api.herokuapp.com")
# http = Net::HTTP.new(uri.host, uri.port)
# http.use_ssl = true ## I think this line is useless

# restful_resource = "/users"
# content = {"user" => {"email"=>"e.r.steinmetz@gmail.com"}}.to_json
# init_header = {"Content-Type" => 'application/json'}

# req = Net::HTTP::Post.new(restful_resource, init_header)
# req.body = content

# response = http.request(req)
# open('test.txt', 'w') do |f|
#   f << "code:#{response.code} message:#{response.message}\n"
#   f << response.body
#   f << "\n\n"
# end

### !!! success: chicken tika masala has been added.  
### now it just needs to be refactored into some sensible methods + test coverage