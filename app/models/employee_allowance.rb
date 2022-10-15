class EmployeeAllowance < ApplicationRecord
  belongs_to :employee
  validates :name, presence: true
  validates :amount, presence: true
end
