FactoryBot.define do
  factory :leafe, class: 'Leave' do
    start_date { "2022-09-18" }
    end_date { "2022-09-18" }
    leave_type { "MyString" }
    reason { "MyText" }
    status { "MyString" }
  end
end
