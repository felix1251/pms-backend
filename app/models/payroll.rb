class Payroll < ApplicationRecord
  belongs_to :company
  has_many :on_payroll_compensations
  has_many :payroll_accounts
  # belongs_to :approver, class_name: "User"
  enum status: { P: "P", A: "A", V: "V"}

  validates :from, presence: true, :if => :from_changed?
  validates :to, presence: true, :if => :to_changed?
  validates :pay_date, presence: true, :if => :pay_date_changed?
end
