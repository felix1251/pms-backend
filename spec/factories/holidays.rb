FactoryBot.define do
  factory :holiday do
    type_of_holiday { "MyString" }
    date { "2022-09-29" }
    company { nil }
  end
end
