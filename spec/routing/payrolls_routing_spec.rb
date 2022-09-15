require "rails_helper"

RSpec.describe PayrollsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/payrolls").to route_to("payrolls#index")
    end

    it "routes to #show" do
      expect(:get => "/payrolls/1").to route_to("payrolls#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/payrolls").to route_to("payrolls#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/payrolls/1").to route_to("payrolls#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/payrolls/1").to route_to("payrolls#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/payrolls/1").to route_to("payrolls#destroy", :id => "1")
    end
  end
end
