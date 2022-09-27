class Offset < ApplicationRecord
  belongs_to :company
  belongs_to :employee
  has_many :overtimes
  enum status: { P: "P", A: "A", D: 'D', V:'V'}
end
