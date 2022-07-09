require "rails_helper"

RSpec.describe DeviceSessionRecordsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/device_session_records").to route_to("device_session_records#index")
    end

    it "routes to #show" do
      expect(:get => "/device_session_records/1").to route_to("device_session_records#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/device_session_records").to route_to("device_session_records#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/device_session_records/1").to route_to("device_session_records#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/device_session_records/1").to route_to("device_session_records#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/device_session_records/1").to route_to("device_session_records#destroy", :id => "1")
    end
  end
end
