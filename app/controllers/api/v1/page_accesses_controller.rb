require 'json'
class Api::V1::PageAccessesController < ApplicationController
  before_action :authorize_access_request!
  before_action :check_backend_session
  before_action :set_page_access, only: [:show, :update, :destroy]

  # GET /page_accesses
  def index
    @page_accesses = PageAccess.all
    render json: @page_accesses
  end

  # GET /page_accesses/1
  def show
    render json: @page_access
  end

  def get_page_acess_for_selection
    page_tree = []
    page = PageAccess.select("id, page AS title, access_code AS key, access_code").all
    action = PageActionAccess.select("id, action AS title, access_code AS key").all
    page.each do |pg|
      if pg.access_code == "H"
        view_only = {}
        action.each do |ac|
          if ac.key == "V"
            view_only = {id: ac.id, title: ac.title, key: "#{pg.key+ac.key}"}
          end
        end
        page_tree.push({id: pg.id, title: pg.title, key: pg.key, children: [view_only]})
      else
        page_tree.push({id: pg.id, title: pg.title, key: pg.key, children: get_action_on_selection(action, pg.key)})
      end
    end
    render json: page_tree.to_json
  end

  # POST /page_accesses
  def create
    @page_access = PageAccess.new(page_access_params)
    if @page_access.save
      render json: @page_access, status: :created, location: @page_access
    else
      render json: @page_access.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /page_accesses/1
  def update
    if @page_access.update(page_access_params)
      render json: @page_access
    else
      render json: @page_access.errors, status: :unprocessable_entity
    end
  end

  # DELETE /page_accesses/1
  def destroy
    @page_access.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page_access
      @page_access = PageAccess.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def page_access_params
      params.fetch(:page_access, {})
    end

    def get_action_on_selection(action, key)
      show_action = []
      action.each do |ac|
        show_action.push({id: ac.id, title: ac.title, key: "#{key+ac.key}"})
      end
      return show_action
    end
end
