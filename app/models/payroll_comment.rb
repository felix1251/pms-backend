class PayrollComment < ApplicationRecord
  serialize :data
  belongs_to :payroll
  belongs_to :user
end
