class Employee < ApplicationRecord
      belongs_to :company
      belongs_to :department
      belongs_to :salary_mode
end
