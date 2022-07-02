class UserPageAccess < ApplicationRecord
      enum status: %i[A I].freeze
end
