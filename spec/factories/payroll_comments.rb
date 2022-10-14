FactoryBot.define do
  factory :payroll_comment do
    payroll { nil }
    type { "" }
    comment { "MyText" }
    user { nil }
    time_sent { "2022-10-14 12:42:24" }
  end
end
