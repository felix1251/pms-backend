class UserPageActionAccess < ApplicationRecord
      belongs_to :user
      belongs_to :page_access
      belongs_to :page_action_access
      enum status: { A: "A", I: "I"}
end
