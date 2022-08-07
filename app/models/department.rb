class Department < ApplicationRecord
      belongs_to :department
      has_many :employees
end
