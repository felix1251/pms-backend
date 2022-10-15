require "rails_helper"

RSpec.describe EmployeeAllowancesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/employee_allowances").to route_to("employee_allowances#index")
    end

    it "routes to #show" do
      expect(:get => "/employee_allowances/1").to route_to("employee_allowances#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/employee_allowances").to route_to("employee_allowances#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/employee_allowances/1").to route_to("employee_allowances#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/employee_allowances/1").to route_to("employee_allowances#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/employee_allowances/1").to route_to("employee_allowances#destroy", :id => "1")
    end
  end
end
