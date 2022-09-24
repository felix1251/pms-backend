FactoryBot.define do
  factory :overtime do
    employee { nil }
    company { nil }
    origin { 1 }
    output { "MyText" }
    start_date { "2022-09-23" }
    end_date { "2022-09-23" }
  end
end
