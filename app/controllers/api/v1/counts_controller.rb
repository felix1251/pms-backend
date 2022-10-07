class Api::V1::CountsController < PmsDesktopController
  before_action :authorize_access_request!
  before_action :check_backend_session

  def counts
    com_id = payload["company_id"]
    sql = "SELECT"
    sql += " (SELECT COUNT(*) FROM users WHERE company_id = #{com_id} and status = 'A') AS accounts,"
    sql += " (SELECT COUNT(*) FROM employees WHERE company_id = #{com_id} and status = 'A') AS employees,"
    sql += " (SELECT COUNT(*) FROM users WHERE company_id = #{com_id} and status = 'A' and online = true) AS online,"
    sql += " (SELECT COUNT(*) FROM payrolls WHERE company_id = #{com_id} and (status = 'P' OR status = 'A')) AS payrolls"

    start_month_of_the_year = Date.today.beginning_of_year.strftime("%Y-%m")

    counts = execute_sql_query(sql)
    render json: counts.first.merge!(graphs)
  end

  def analystic
    render json: graphs
  end


  def token_claims
    {
      aud: allowed_aud,
      verify_aud: true
    }
  end

  private

  def graphs
    com_id = payload["company_id"]
    start_month_of_the_year = Date.today.beginning_of_year.strftime("%Y-%m")
    end_month_of_the_year = Date.today.strftime("%Y-%m")
    result = (start_month_of_the_year..end_month_of_the_year).map(&:to_s)

    start_year = 20.years.ago.strftime("%Y")
    end_year = Date.today.strftime("%Y")

    years =  (start_year..end_year).map(&:to_s)

    hired_graph_sql = "SELECT"
    result.each do |s|
      hired_graph_sql += "(SELECT COUNT(*) FROM employees WHERE company_id = #{com_id} and DATE_FORMAT(date_hired, '%Y-%m') = '#{s}') AS '#{s}'"
      hired_graph_sql += "," if s != end_month_of_the_year
    end

    separated_graph_sql = "SELECT"
    result.each do |s|
      separated_graph_sql += "(SELECT COUNT(*) FROM employees WHERE company_id = #{com_id} and DATE_FORMAT(date_resigned, '%Y-%m') = '#{s}') AS '#{s}'"
      separated_graph_sql += "," if s != end_month_of_the_year
    end

    hired_graph = execute_sql_query(hired_graph_sql)
    separated_graph = execute_sql_query(separated_graph_sql)
    return {hired_graph: hired_graph.first.values, separated_graph: separated_graph.first.values, years: years}
  end

  def allowed_aud
    ["HV"]
  end
end
