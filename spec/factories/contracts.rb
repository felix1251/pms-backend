FactoryBot.define do
  factory :contract do
    company { nil }
    start_date { "2022-10-08" }
    end_date { "2022-10-08" }
    remarks { "MyString" }
  end
end
