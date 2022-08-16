class Company < ApplicationRecord
      has_many :users
      has_many :employees
      has_many :departments

      validates :code, format: { without: /\s/ , message: 'cannot contain whitespace' }, presence: true
      validates :description, presence: true
end
