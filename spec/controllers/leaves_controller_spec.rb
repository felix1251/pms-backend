require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.
#
# Also compared to earlier versions of this generator, there are no longer any
# expectations of assigns and templates rendered. These features have been
# removed from Rails core in Rails 5, but can be added back in via the
# `rails-controller-testing` gem.

RSpec.describe LeavesController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Leave. As you add validations to Leave, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # LeavesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      leave = Leave.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      leave = Leave.create! valid_attributes
      get :show, params: {id: leave.to_param}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Leave" do
        expect {
          post :create, params: {leave: valid_attributes}, session: valid_session
        }.to change(Leave, :count).by(1)
      end

      it "renders a JSON response with the new leave" do

        post :create, params: {leave: valid_attributes}, session: valid_session
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
        expect(response.location).to eq(leave_url(Leave.last))
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new leave" do

        post :create, params: {leave: invalid_attributes}, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested leave" do
        leave = Leave.create! valid_attributes
        put :update, params: {id: leave.to_param, leave: new_attributes}, session: valid_session
        leave.reload
        skip("Add assertions for updated state")
      end

      it "renders a JSON response with the leave" do
        leave = Leave.create! valid_attributes

        put :update, params: {id: leave.to_param, leave: valid_attributes}, session: valid_session
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the leave" do
        leave = Leave.create! valid_attributes

        put :update, params: {id: leave.to_param, leave: invalid_attributes}, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested leave" do
      leave = Leave.create! valid_attributes
      expect {
        delete :destroy, params: {id: leave.to_param}, session: valid_session
      }.to change(Leave, :count).by(-1)
    end
  end

end
