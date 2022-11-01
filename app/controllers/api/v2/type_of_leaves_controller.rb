class Api::V2::TypeOfLeavesController < PmsErsController
  before_action :authorize_access_request!

  def index
    type_of_leaves = TypeOfLeave.select('id, name')
    render json: type_of_leaves
  end
end
