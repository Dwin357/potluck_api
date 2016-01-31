

class ApiPlugin
  attr_reader :potluck_items
  def initialize
    @my_key
    @potluck_items
    @ready

    load_my_key
  end

  def new_user(user_email)
    save_my_key(
      fetch_new_api_key(
        user_email
      )
    )
    load_my_key
  end

  def ready?
    @ready
  end

  # private
  attr_accessor :my_key
  attr_writer :ready

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

  def fetch_new_api_key(user_email)
    user_email
  end

  def save_my_key(new_api_key)
    File.open("api_key.txt", "w") { |f| f.write(new_api_key) }
  end


end

# tst = ApiPlugin.new
# puts tst.has_api_key?
# tst.new_user("test22@email")
# puts tst.has_api_key?
