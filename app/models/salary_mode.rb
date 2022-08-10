class SalaryMode < ApplicationRecord
      has_many :employees
      before_create :auto_upcase_desc
      before_update :auto_upcase_desc

      private

      def auto_upcase_desc
            self.description = self.description.upcase
            self.code = self.code.upcase
      end
end
