class AssignedArea < ApplicationRecord
  belongs_to :company
  has_many :employees
  belongs_to :created_by, class_name: "User"
  before_create :auto_upcase
  before_update :auto_upcase

  validates :name, presence: true, uniqueness: { scope: :company_id, case_sensitive: false, message: "already exist"}
  validates :code, presence: true, format: { without: /\s/ , message: 'cannot contain whitespace' }, uniqueness: { scope: :company_id, case_sensitive: false, message: "already exist"}
  enum status: { A: "A", I: "I"}

  private

  def auto_upcase
    self.name = self.name.upcase
    self.code = self.code.upcase
  end
end
