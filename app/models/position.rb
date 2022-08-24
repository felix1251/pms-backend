class Position < ApplicationRecord
  belongs_to :company
  has_many :employees
  before_create :auto_upcase
  before_update :auto_upcase
  validates :name, presence: true, uniqueness: { scope: :company_id, case_sensitive: false}
  validates :code, presence: true
  enum status: { A: "A", I: "I"}
  
  def auto_upcase
    self.name = self.name.upcase
    self.code = self.code.upcase
  end
end
