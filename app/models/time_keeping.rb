class TimeKeeping < ApplicationRecord
      belongs_to :company
      validates :date, uniqueness: { scope: [:company_id, :biometric_no], message: "already exist" }, presence: true
      validates :status, presence: true
      validates :verified, presence: true
      validates :device_id, presence: false
      validates :biometric_no, presence: true
      validates :work_code, presence: true
end
