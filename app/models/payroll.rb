class Payroll < ApplicationRecord
  belongs_to :company
  # belongs_to :approver, class_name: "User"
  enum status: { P: "P", A: "A", V: "V"}

  validates :from, presence: true
  validates :to, presence: true
  validates :pay_date, presence: true
end
