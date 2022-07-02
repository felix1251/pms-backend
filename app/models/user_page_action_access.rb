class UserPageActionAccess < ApplicationRecord
      enum status: %i[A I].freeze
end
