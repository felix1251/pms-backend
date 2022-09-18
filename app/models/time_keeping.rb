class TimeKeeping < ApplicationRecord
      belongs_to :company
      validates :date, uniqueness: { scope: [:company_id, :biometric_no], message: "already exist" }, presence: true
      validates :status, presence: true
      validates :verified, presence: true
      validates :device_id, presence: true
      validates :biometric_no, presence: true
      validates :work_code, presence: true
      # enum status: [ 0, 1, 255]
end
