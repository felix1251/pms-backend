class PageAccess < ApplicationRecord
      has_many :user_page_accesses
      validates :access_code, uniqueness: { case_sensitive: false }
      validates :position, uniqueness: true
end
