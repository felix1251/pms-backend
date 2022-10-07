class PageActionAccess < ApplicationRecord
      has_many :user_page_accesses
      has_many :user_page_action_accesses
end
