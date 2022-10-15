FactoryBot.define do
  factory :on_payroll_adjustment do
    payroll { nil }
    employee { nil }
    description { "MyString" }
    amount { "9.99" }
  end
end
