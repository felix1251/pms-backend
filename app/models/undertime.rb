class Undertime < ApplicationRecord
  belongs_to :company
  belongs_to :employee

  enum status: { P: "P", A: "A", D: 'D', V:'V'}

  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :reason, presence: true

  validate :check_date_validation, :if => [:start_time_changed?, :end_time_changed?]

  private

  def check_date_validation
    if (Undertime.where("(? BETWEEN start_time AND end_time OR ? BETWEEN start_time AND end_time) AND employee_id = ? AND status IN ('A','P')", self.start_time, self.end_time, self.employee_id).any?)
          errors.add(:end_time, 'Employee undertime date range overlaps or already exist')
    end
  end

end
