class Company < ApplicationRecord
      serialize :worker_pid_list, Array
      has_many :users
      has_many :employees
      has_many :departments
      has_many :positions
      has_many :job_classifications
      has_many :time_keepings
      has_many :leaves
      has_many :official_businesses
      has_many :contracts
      before_create :set_json_default

      validates :code, format: { without: /\s/ , message: 'cannot contain whitespace' }, presence: true, uniqueness: { case_sensitive: false }
      validates :description, presence: true, uniqueness: { case_sensitive: false }

      private

      def set_json_default
            self.settings ||= {}
            self.employee_approvers ||= []
            self.schedule_approvers ||= []
            self.time_keeping_approvers ||= []
            self.request_administrative_approvers ||= []
            self.request_supervisory_approvers ||= []
      end
end
