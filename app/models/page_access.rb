class PageAccess < ApplicationRecord
      has_many :user_page_accesses
      enum access_code: { D: "D", P: "P", T: "T", S: "S"}
end
