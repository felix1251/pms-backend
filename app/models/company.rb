class Company < ApplicationRecord
      has_many :users
      has_many :employees
      has_many :departments
      has_many :positions
      has_many :job_classifications
      has_many :time_keepings
      has_many :leaves
      has_many :official_businesses

      validates :code, format: { without: /\s/ , message: 'cannot contain whitespace' }, presence: true
      validates :description, presence: true
end
