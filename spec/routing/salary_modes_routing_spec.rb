require "rails_helper"

RSpec.describe SalaryModesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/salary_modes").to route_to("salary_modes#index")
    end

    it "routes to #show" do
      expect(:get => "/salary_modes/1").to route_to("salary_modes#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/salary_modes").to route_to("salary_modes#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/salary_modes/1").to route_to("salary_modes#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/salary_modes/1").to route_to("salary_modes#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/salary_modes/1").to route_to("salary_modes#destroy", :id => "1")
    end
  end
end
