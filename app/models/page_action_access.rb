class PageActionAccess < ApplicationRecord
      has_many :user_page_accesses
      has_many :user_page_action_accesses
      enum access_code: { V: "V", A: "A", E: "E", D: "D", X: "X"}
end
