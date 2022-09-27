class Overtime < ApplicationRecord
  belongs_to :employee
  belongs_to :company
  belongs_to :offset, optional: true
  enum status: { P: "P", A: "A", D: 'D', V:'V'}
end
