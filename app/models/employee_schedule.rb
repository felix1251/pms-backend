class EmployeeSchedule < ApplicationRecord
  belongs_to :employee
  validates :start_time, presence: true
  validates :end_time, presence: true
  validate :no_date_overlap, :if => [:start_time_changed?, :end_time_changed?]

  private

  def no_date_overlap
    if (EmployeeSchedule.where("(? BETWEEN start_time AND end_time OR ? BETWEEN start_time AND end_time) AND employee_id = ?", self.start_time, self.end_time, self.employee_id).any?)
        errors.add(:end_time, 'Employee time range overlaps or already exist')
    end
  end
end
