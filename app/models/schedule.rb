class Schedule < ApplicationRecord
      belongs_to :company
      validates :start_date, presence: true
      validates :end_date, presence: true
      validates :title, presence: true
      validate :no_date_overlap, :if => [:start_date_changed?,:end_date_changed?]

      private

      def no_date_overlap
            if (Schedule.where("(? BETWEEN start_date AND end_date OR ? BETWEEN start_date AND end_date) AND department_id = ?", self.start_date, self.end_date, self.department_id).any?)
                  errors.add(:department_id, 'Schedule with this department date range overlaps or already exist')
            end
      end
end
