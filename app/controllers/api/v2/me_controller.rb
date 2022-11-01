class Api::V2::MeController < PmsErsController
      before_action :authorize_access_request!
      def me
            sql = " SELECT"
            sql += " emp.profile, dep.name AS department_name, pos.name AS position, emp.biometric_no, emp.employee_id,"
            sql += " CONCAT(emp.last_name, ', ', emp.first_name, ' ', CASE WHEN emp.suffix = '' THEN '' ELSE CONCAT(emp.suffix, '.') END,' '," 
            sql += " CASE emp.middle_name WHEN '' THEN '' ELSE CONCAT(SUBSTR(emp.middle_name, 1, 1), '.') END) AS fullname"
            sql += " FROM employees AS emp"
            sql += " LEFT JOIN departments AS dep ON dep.id = emp.department_id"
            sql += " LEFT JOIN positions AS pos ON pos.id = emp.position_id"
            sql += " WHERE emp.id = #{payload['employee_id']}"
            sql += " LIMIT 1"

            result = execute_sql_query(sql).first
            render json: result
      end
end