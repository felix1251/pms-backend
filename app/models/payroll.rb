class Payroll < ApplicationRecord
  belongs_to :company
  # belongs_to :approver, class_name: "User"
  enum status: { P: "P", A: "A", V: "V"}

  validates :from, presence: true, uniqueness: { scope: :company_id }, :if => :from_changed?
  validates :to, presence: true, uniqueness: { scope: :company_id }, :if => :to_changed?
  validates :pay_date, presence: true, uniqueness: { scope: :company_id }, :if => :pay_date_changed?
end
