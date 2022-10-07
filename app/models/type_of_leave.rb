class TypeOfLeave < ApplicationRecord
      enum status: { A: "A", I: "I"}
      validates :name, uniqueness: { case_sensitive: false }
end
