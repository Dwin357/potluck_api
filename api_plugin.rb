require_relative "api_key"

class ApiPlugin

  APP_ROOT = File.expand_path("..", __FILE__)

  def has_api_key?
    false unless MY_KEY && MY_KEY != nil
  end

  def get_key(user_email)
    set_api_key(user_email)
  end

  def set_api_key(key)
    File.open("#{APP_ROOT}/api_key.rb", "w") do |f|
      f.write("MY_KEY=\"#{key}\"")
    end
  end
end

# tst = ApiPlugin.new
# puts tst.has_api_key?