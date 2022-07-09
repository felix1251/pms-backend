require "rails_helper"

RSpec.describe SessionRecordsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/session_records").to route_to("session_records#index")
    end

    it "routes to #show" do
      expect(:get => "/session_records/1").to route_to("session_records#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/session_records").to route_to("session_records#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/session_records/1").to route_to("session_records#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/session_records/1").to route_to("session_records#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/session_records/1").to route_to("session_records#destroy", :id => "1")
    end
  end
end
