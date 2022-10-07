class Holiday < ApplicationRecord
  belongs_to :company
  enum type_of_holiday: { S: "S", R: "R"}
  validates :title, presence: true
  validates :date, presence: true
  validates :date, uniqueness: { scope: :company_id }
end
