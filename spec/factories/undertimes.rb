FactoryBot.define do
  factory :undertime do
    start_time { "2022-10-28 16:29:47" }
    end_time { "2022-10-28 16:29:47" }
    status { "MyString" }
    company { nil }
    employee { nil }
    origin { 1 }
    reason { "MyText" }
  end
end
