require_relative "../interface"

describe Interface do
  # there was a rule here, person who receives decides if they can use X
  # it is the job of the caller to verify the format of a message / interface
  # it is NOT the job of the seder to verify
  # ie, this is the main test case for the interface & the app
  let(:subject) { Interface.new }
  let(:api_plugin_exemplar) { ApiPlugin.new }

  describe "#display(obj)" do
    it "outputs obj.to_s to terminal"
  end

  describe "#run" do
    it "breaks when command is 'exit'"
    it "loops when command is not 'exit'"
  end

  describe "#execute_command" do
    # this should be mocked with what the expected behavior of the api_plugin is
    it "calls X on the api"
    it "calls Y on the api"
    it "calls Z on the api"
  end

  describe "integration test with api_plugin" do
    # this confirms the api_plugin's behavior conforms to interfaces expectations
    it "api_plugin.method_X"
    it "api_plugin.method_Y"
    it "api_plugin.method_Z"
  end
end