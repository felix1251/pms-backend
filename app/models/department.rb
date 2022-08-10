class Department < ApplicationRecord
      belongs_to :company
      has_many :employees

      before_create :auto_upcase_name
      before_update :auto_upcase_name

      private

      def auto_upcase_name
            self.name = self.name.upcase
            self.code = self.code.upcase
      end
end
