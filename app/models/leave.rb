class Leave < ApplicationRecord
      enum status: { P: "P", A: "A", D: 'D', V:'V'}
end
