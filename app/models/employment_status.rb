class EmploymentStatus < ApplicationRecord
      has_many :employees
      before_create :auto_upcase
      before_update :auto_upcase
      enum status: { A: "A", I: "I"}
      validates :name, uniqueness: { case_sensitive: false }
      validates :code, uniqueness: { case_sensitive: false }

      private

      def auto_upcase
            self.name = self.name.upcase
            self.code = self.code.upcase
      end
end
