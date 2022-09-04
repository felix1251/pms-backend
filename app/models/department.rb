class Department < ApplicationRecord
      belongs_to :company
      has_many :employees
      belongs_to :created_by, class_name: "User"
      before_create :auto_upcase_name
      before_update :auto_upcase_name

      validates :name, presence: true, uniqueness: { scope: :company_id, case_sensitive: false, message: "already exist"}, length: {maximum: 50}
      validates :code, presence: true, format: { without: /\s/ , message: 'cannot contain whitespace' }, uniqueness: { scope: :company_id, case_sensitive: false, message: "already exist"}, length: {maximum: 15}
      enum status: { A: "A", I: "I"}

      private

      def auto_upcase_name
            self.name = self.name.upcase
            self.code = self.code.upcase
      end
end
