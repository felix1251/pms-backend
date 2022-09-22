require "rails_helper"

RSpec.describe OnPayrollCompensationsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/on_payroll_compensations").to route_to("on_payroll_compensations#index")
    end

    it "routes to #show" do
      expect(:get => "/on_payroll_compensations/1").to route_to("on_payroll_compensations#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/on_payroll_compensations").to route_to("on_payroll_compensations#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/on_payroll_compensations/1").to route_to("on_payroll_compensations#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/on_payroll_compensations/1").to route_to("on_payroll_compensations#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/on_payroll_compensations/1").to route_to("on_payroll_compensations#destroy", :id => "1")
    end
  end
end
