class EmployeeActionHistory < ApplicationRecord
      belongs_to :action_by, class_name: "User"
      belongs_to :employee
end
