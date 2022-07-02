class PageActionAccess < ApplicationRecord
      enum access_code: %i[A E D X].freeze
end
