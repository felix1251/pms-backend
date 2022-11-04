class Offset < ApplicationRecord
      belongs_to :company
      belongs_to :employee
      has_many :overtimes
      enum status: { P: "P", A: "A", D: 'D', V:'V'}
      
      validates :offset_date, presence: true
      validate :no_date_overlap, :if => :offset_date_changed?
      validate :check_credits, :if => :offset_date_changed?

      private

      def no_date_overlap
            if (Offset.where("offset_date = ? AND employee_id = ? AND status IN ('A','P')", self.offset_date, self.employee_id).any?)
                  errors.add(:offset_date, 'Employee offset date already exist')
            end
      end

      def check_credits
            if offset_credits.to_d < 8
                  errors.add(:credits, 'Not enough offset credits')
            end
      end

      def offset_credits
            today = Date.today
            start_of_the_year = today.beginning_of_year.strftime("%Y-%m-%d")
            end_of_the_year = today.end_of_year.strftime("%Y-%m-%d")

            sql = "SELECT (final.overtime_credits"
            sql += " - IFNULL((SELECT SUM(8) FROM offsets AS ofc WHERE ofc.employee_id = #{self.employee_id}"
            sql += " AND (ofc.offset_date BETWEEN '#{start_of_the_year}' AND '#{end_of_the_year}')"
            sql += " AND ofc.status IN ('A','P') ), 0)) AS total"
            sql += " FROM ("
            sql += " SELECT SUM(TRUNCATE((TIMESTAMPDIFF("
            sql += " MINUTE, DATE_FORMAT(ov.start_date, '%Y-%m-%d %H:%i'), DATE_FORMAT(end_date, '%Y-%m-%d %H:%i'))/60),2)) AS overtime_credits"
            sql += " FROM overtimes ov"
            sql += " WHERE ov.employee_id = #{self.employee_id} AND ov.status = 'A' AND ov.billable = 0"
            sql += " AND (ov.start_date BETWEEN '#{start_of_the_year}' AND '#{end_of_the_year}')"
            sql += " ) final"

            return ActiveRecord::Base.connection.exec_query(sql).first["total"] || "0.0"
      end
end
