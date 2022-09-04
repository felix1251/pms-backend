class SessionRecord < ApplicationRecord
      belongs_to :user
      validates :current_device_id, presence: true
      enum status: { A: "A", I: "I"}
end
