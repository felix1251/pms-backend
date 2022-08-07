class Company < ApplicationRecord
      has_many :users
      has_many :employees
      has_many :departments
end
