class Contract < ApplicationRecord
  belongs_to :company
  validates :start_date, presence: true
  validates :end_date, presence: true

end
