class Undertime < ApplicationRecord
  belongs_to :company
  belongs_to :employee

  enum status: { P: "P", A: "A", D: 'D', V:'V'}

  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :reason, presence: true

  validate :check_date_validation, :if => [:start_date_changed?, :end_date_changed?]

  private

  def check_date_validation
    if (Undertime.where("(? BETWEEN start_date AND end_date OR ? BETWEEN start_date AND end_date) AND employee_id = ? AND status IN ('A','P')", self.start_date, self.end_date, self.employee_id).any?)
          errors.add(:end_date, 'Employee undertime date range overlaps or already exist')
    end
  end

end
