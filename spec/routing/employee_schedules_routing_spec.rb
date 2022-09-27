require "rails_helper"

RSpec.describe EmployeeSchedulesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/employee_schedules").to route_to("employee_schedules#index")
    end

    it "routes to #show" do
      expect(:get => "/employee_schedules/1").to route_to("employee_schedules#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/employee_schedules").to route_to("employee_schedules#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/employee_schedules/1").to route_to("employee_schedules#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/employee_schedules/1").to route_to("employee_schedules#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/employee_schedules/1").to route_to("employee_schedules#destroy", :id => "1")
    end
  end
end
