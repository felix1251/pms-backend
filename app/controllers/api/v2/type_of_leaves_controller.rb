class Api::V2::TypeOfLeavesController < PmsErsController
  before_action :authorize_access_request!

  def index
    sql = "SELECT"
    sql += " id, name, code"
    sql += " FROM type_of_leaves"
    type_of_leaves = execute_sql_query(sql)
    render json: type_of_leaves
  end

end
