class JobClassification < ApplicationRecord
  belongs_to :company
  belongs_to :created_by, class_name: "User"
  before_create :auto_upcase
  before_update :auto_upcase

  validates :description, presence: true

  private

  def auto_upcase
    self.description = self.description.upcase
  end
end
