class Leave < ApplicationRecord
      belongs_to :employee
      belongs_to :company
      enum status: { P: "P", A: "A", D: 'D', V:'V'}

      validates :start_date, presence: true
      validates :end_date, presence: true
      validates :reason, presence: true

      validate :check_date_validation, :if => [:start_date_changed?, :end_date_changed?]
      validate :check_max_credit, :if => [:start_date_changed?, :end_date_changed?]

      private

      def check_date_validation
            if (Leave.where("(? BETWEEN start_date AND end_date OR ? BETWEEN start_date AND end_date) AND employee_id = ? AND status IN ('A','P')", self.start_date, self.end_date, self.employee_id).any?)
                  errors.add(:end_date, 'Employee leave date range overlaps or already exist')
            end
      end

      def check_max_credit
            tol = TypeOfLeave.select(:code).find(self.leave_type)
            if tol.code = "VLWP" || tol.code = "SLWP"
                  curr_number_of_days = self.half_day ? 0.5 : (self.start_date..self.end_date).map(&:to_s).count
                  if (leave_credits(tol.code).to_d + curr_number_of_days) > tol.code = "VLWP"  ? self.company.max_vacation_leave_credit : self.company.max_sick_leave_credit
                        errors.add(:credits, 'Leave credits exceed, pending leaves are counted in creation make sure pending leaves are voided or rejected')
                  end
            end
      end

      def leave_credits(code)
            today = Date.today
            start_of_the_year = today.beginning_of_year.strftime("%Y-%m-%d")
            end_of_the_year = today.end_of_year.strftime("%Y-%m-%d")

            sql = "SELECT"
            sql += " SUM(CASE le.half_day WHEN 0 THEN (DATEDIFF(le.end_date, le.start_date) + 1) ELSE 0.5 END) AS days"
            sql += " FROM leaves AS le"
            sql += " WHERE le.employee_id = #{self.employee_id} AND le.leave_type = #{self.leave_type} AND le.status IN ('A', 'P')"
            sql += " AND (le.start_date BETWEEN '#{start_of_the_year}' AND '#{end_of_the_year}')"

            return ActiveRecord::Base.connection.exec_query(sql).first["days"] || "0.0"
      end
end
