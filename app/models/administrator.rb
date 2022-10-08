class Administrator < ApplicationRecord
      has_secure_password
      validates :name, presence: true
      validates :username, presence: true
      
      def attributes
            super.except('password_digest')
      end
end
