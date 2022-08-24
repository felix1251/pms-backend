require "rails_helper"

RSpec.describe JobClassificationsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/job_classifications").to route_to("job_classifications#index")
    end

    it "routes to #show" do
      expect(:get => "/job_classifications/1").to route_to("job_classifications#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/job_classifications").to route_to("job_classifications#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/job_classifications/1").to route_to("job_classifications#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/job_classifications/1").to route_to("job_classifications#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/job_classifications/1").to route_to("job_classifications#destroy", :id => "1")
    end
  end
end
