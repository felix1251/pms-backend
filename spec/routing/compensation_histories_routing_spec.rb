require "rails_helper"

RSpec.describe CompensationHistoriesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/compensation_histories").to route_to("compensation_histories#index")
    end

    it "routes to #show" do
      expect(:get => "/compensation_histories/1").to route_to("compensation_histories#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/compensation_histories").to route_to("compensation_histories#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/compensation_histories/1").to route_to("compensation_histories#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/compensation_histories/1").to route_to("compensation_histories#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/compensation_histories/1").to route_to("compensation_histories#destroy", :id => "1")
    end
  end
end
