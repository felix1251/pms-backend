FactoryBot.define do
  factory :official_business do
    start_date { "2022-09-21" }
    end_date { "2022-09-21" }
    client { "MyString" }
    reason { "MyText" }
    status { "MyString" }
    origin { 1 }
  end
end
