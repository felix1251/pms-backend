class Subject < ApplicationRecord
    belongs_to :college, :dependent => :delete
    belongs_to :curriculum, optional: true, :dependent => :delete
    has_many :prerequisites

    validates :code, presence: true, uniqueness: true, length: { maximum: 10, too_long: "%{count} characters is the maximum allowed" }
end
