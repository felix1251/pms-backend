class OfficialBusiness < ApplicationRecord
      belongs_to :employee
      belongs_to :company
      enum status: { P: "P", A: "A", D: 'D', V:'V'}
end
