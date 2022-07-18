class PageAccess < ApplicationRecord
      has_many :user_page_accesses
      enum access_code: { H: "H", P: "P", T: "T", S: "S", E: "E", B: "B"}
end
