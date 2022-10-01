class Holiday < ApplicationRecord
  belongs_to :company
  enum type_of_holiday: { S: "S", R: "R"}
end
