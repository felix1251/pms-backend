class UserPageAccess < ApplicationRecord
      belongs_to :user
      belongs_to :page_access
      enum status: { A: "A", I: "I"}
end
