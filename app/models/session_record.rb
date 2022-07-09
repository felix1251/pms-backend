class SessionRecord < ApplicationRecord
      belongs_to :user
      enum status: { A: "A", I: "I"}
end
