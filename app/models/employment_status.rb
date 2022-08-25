class EmploymentStatus < ApplicationRecord
      has_many :employees
      before_create :auto_upcase
      before_update :auto_upcase
      enum status: { A: "A", I: "I"}

      private

      def auto_upcase
            self.name = self.name.upcase
      end
end
