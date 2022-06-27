class Curriculum < ApplicationRecord
    belongs_to :college
    has_many :subjects, :dependent => :delete_all
    has_many :users, :dependent => :delete_all
    
    validates :code, presence: true, uniqueness: true, length: { maximum: 10, too_long: "%{count} characters is the maximum allowed" }
end
