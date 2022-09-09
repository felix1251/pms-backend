require "rails_helper"

RSpec.describe FailedTimeKeepingsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/failed_time_keepings").to route_to("failed_time_keepings#index")
    end

    it "routes to #show" do
      expect(:get => "/failed_time_keepings/1").to route_to("failed_time_keepings#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/failed_time_keepings").to route_to("failed_time_keepings#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/failed_time_keepings/1").to route_to("failed_time_keepings#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/failed_time_keepings/1").to route_to("failed_time_keepings#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/failed_time_keepings/1").to route_to("failed_time_keepings#destroy", :id => "1")
    end
  end
end
