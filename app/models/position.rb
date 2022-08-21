class Position < ApplicationRecord
  belongs_to :company
  enum status: { A: "A", I: "I"}
end
