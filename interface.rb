require_relative "api_plugin"

class Interface
  attr_accessor :api_plugin, :command
  def initialize
    @api_plugin = ApiPlugin.new
    @command = set_initial_command
  end

  def set_initial_command
    if api_plugin.has_api_key?
      command = "new_key"
    else
      command = ""
    end
  end

  def run
    greeting
    while command != "exit" do
      execute_command
      puts
      fetch_new_command
    end
  end

  def execute_command
    case command
    when "help"
      display(help)
    when "new_key"
      display("you have not registered yet; enter your email")
      api_plugin.get_key(fetch_email)
      api_plugin = ApiPlugin.new
    end
  end

  def greeting
    puts "Welcome to UL Potluck API, you may type 'help' for a list of commands"
  end

  def fetch_new_command
    print ">>"
    command = gets.chomp
  end

  def fetch_email
    print ">>"
    email = gets.chomp
    email
  end

  def help
    "help: displays list of commands\nexit: ends program"
  end

  def display(object)
    puts object
  end
end