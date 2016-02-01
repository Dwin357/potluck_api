require_relative "api_plugin"

class Interface
  attr_accessor :api_plugin, :command
  def initialize
    @api_plugin = ApiPlugin.new
    @command    = set_opening_command
  end

  def run
    display(greeting)
    loop do
      # these would ideally be enums instead of strings
      # but that needs a gem or Java
      case command
      when "exit", "-x"
        break
      when "help", "-h"
        display(help)
        next_command
      when "new_user", "-nu"
        api_plugin.new_user(fetch_user_input("provide your email to sign up"))
        command_per_api_status
      when "new_item", "-ni"
        api_plugin.new_potluck_item(fetch_user_input("what will you bring?"))
        command_per_api_status
      when "items", "-i"
        api_plugin.potluck_items.each do |item|
          display(item)
        end
        next_command
      when "errors", "-e"
        if api_plugin.errors
          api_plugin.errors.each do |error|
            display(error)
          end
        else
          display("no errors, good job")
        end
        next_command
      end
    end
  end

  def fetch_user_input(message = nil)
    puts message if message
    print ">>"
    input = gets.chomp
    input
  end

  def next_command
    self.command = fetch_user_input
  end

  def set_opening_command
    if api_plugin.ready?
      self.command = "-i"
    else
      self.command = "-nu"
    end
  end

  def command_per_api_status
    if api_plugin.ready?
      self.command = "-i"
    else
      self.command = "-e"
    end
  end

  def greeting
    "Welcome to UL Potluck API, you may type 'help' for a list of commands"
  end

  def display(output)
    puts output
  end

  def help
    "help -h: displays a list of commands\nexit -x: exits program\nnew_user -nu: resets your credentials to a new email\nnew_item -ni: adds an item you promise to bring to the party\nitems -i: displays a list of the items people are brining\nerrors -e: displays a list of errors being experienced"
  end
end