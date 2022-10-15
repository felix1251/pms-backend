class Payroll < ApplicationRecord
  belongs_to :company
  belongs_to :pagibig, optional: true
  has_many :on_payroll_compensations, dependent: :destroy
  has_many :payroll_accounts, dependent: :destroy
  has_many :on_payroll_allowances, dependent: :destroy
  has_many :payroll_comments, dependent: :destroy
  has_many :on_payroll_allowances, dependent: :destroy
  has_many :on_payroll_adjustments, dependent: :destroy
  enum status: { P: "P", A: "A", V: "V"}
  validates :from, presence: true, :if => :from_changed?
  validates :to, presence: true, :if => :to_changed?
  validates :pay_date, presence: true, :if => :pay_date_changed?
  validate :no_date_overlap, :if => [:from_changed?, :to_changed?]

  private

  def no_date_overlap
    if (Payroll.where("(? BETWEEN payrolls.from AND payrolls.to OR ? BETWEEN payrolls.from AND payrolls.to) AND payrolls.company_id = ?", self.from, self.to, self.company_id).any?)
          errors.add(:from, 'payroll cut-off date overlaps or already exist')
    end
  end
end
