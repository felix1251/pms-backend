class PageAccess < ApplicationRecord
      enum access_code: %i[D P T].freeze
end
