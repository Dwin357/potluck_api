require_relative "../api_plugin"

describe ApiPlugin do
  # there was a rule here, person who receives decides if they can use X
  # it is the job of the caller to verify the format of a message / interface
  # it is NOT the job of the seder to verify
  # ie, this is the main test case for the interface & the app
  let(:subject) { ApiPlugin.new }

  describe "api_key behavior" do
    it "promps user for email if no key is saved" do
      File.open("api_key.txt", "w"){ |f| f.truncate(0) }
      expect(subject.ready?).to be false
    end
    it "formats post request to known format"
    it "receives my_key upon request"
    it "saves my_key in seperate file"
    it "acesses my_key through an environment constant"
  end

  describe "potluck-items" do
    it "formats item-get request to known format"
    it "receives items upon request"
    it "formats item-post request to known format"
    it "sends new item-get request after an item post request"
  end

  describe "integration test with ul potluck-api" do
    it "new-user post"
    it "items get"
    it "new-item post"
  end

end