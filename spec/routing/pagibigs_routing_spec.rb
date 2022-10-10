require "rails_helper"

RSpec.describe PagibigsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/pagibigs").to route_to("pagibigs#index")
    end

    it "routes to #show" do
      expect(:get => "/pagibigs/1").to route_to("pagibigs#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/pagibigs").to route_to("pagibigs#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/pagibigs/1").to route_to("pagibigs#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/pagibigs/1").to route_to("pagibigs#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/pagibigs/1").to route_to("pagibigs#destroy", :id => "1")
    end
  end
end
