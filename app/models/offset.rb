class Offset < ApplicationRecord
  belongs_to :company
  belongs_to :employee
  has_many :overtimes
  enum status: { P: "P", A: "A", D: 'D', V:'V'}
  validates :offset_date, presence: true

  validate :no_date_overlap, :if => :offset_date_changed?

  private

  def no_date_overlap
        if (Offset.where("offset_date = ? AND employee_id = ? AND (status = 'P' OR status = 'A')", self.offset_date, self.employee_id).any?)
              errors.add(:offset_date, 'Employee offset date already exist')
        end
  end
end
