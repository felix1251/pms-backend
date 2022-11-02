class Leave < ApplicationRecord
      belongs_to :employee
      belongs_to :company
      enum status: { P: "P", A: "A", D: 'D', V:'V'}
      
      validate :no_date_overlap, :if => [:start_date_changed?, :end_date_changed?]

      private

      def no_date_overlap
            if (Leave.where("(? BETWEEN start_date AND end_date OR ? BETWEEN start_date AND end_date) AND employee_id = ?", self.start_date, self.end_date, self.employee_id).any?)
                  errors.add(:end_date, 'Employee leave date range overlaps or already exist')
            end
      end
end
