class CompanyAccount < ApplicationRecord
  belongs_to :company
  has_many :employees
  before_create :auto_upcase
  before_update :auto_upcase
  
  validates :name, presence: true, uniqueness: { scope: :company_id, case_sensitive: false, message: "already exist"}, length: {maximum: 50}
  validates :code, presence: true, format: { without: /\s/ , message: 'cannot contain whitespace' }, uniqueness: { scope: :company_id, case_sensitive: false, message: "already exist"}, length: {maximum: 15}

  def auto_upcase
    self.name = self.name.upcase
    self.code = self.code.upcase
  end
end
