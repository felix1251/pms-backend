class CompanyAccount < ApplicationRecord
  belongs_to :company
  has_many :employees
  has_many :schedules
  before_create :auto_upcase
  before_update :auto_upcase
  
  validates :name, presence: true, uniqueness: { scope: :company_id, case_sensitive: false, message: "already exist"}, length: {maximum: 50}
  validates :code, presence: true, format: { without: /\s/ , message: 'cannot contain whitespace' }, uniqueness: { scope: :company_id, case_sensitive: false, message: "already exist"}, length: {maximum: 15}
  enum status: { A: "A", I: "I"}

  def auto_upcase
    self.name = self.name.upcase
    self.code = self.code.upcase
    self.approvers ||= []
    self.approvers = self.approvers.uniq
  end
end
