class PageAccess < ApplicationRecord
      enum access_code: { D: "D", P: "P", T: "T", S: "S"}
end
