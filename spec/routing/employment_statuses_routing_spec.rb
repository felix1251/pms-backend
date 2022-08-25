require "rails_helper"

RSpec.describe EmploymentStatusesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/employment_statuses").to route_to("employment_statuses#index")
    end

    it "routes to #show" do
      expect(:get => "/employment_statuses/1").to route_to("employment_statuses#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/employment_statuses").to route_to("employment_statuses#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/employment_statuses/1").to route_to("employment_statuses#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/employment_statuses/1").to route_to("employment_statuses#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/employment_statuses/1").to route_to("employment_statuses#destroy", :id => "1")
    end
  end
end
