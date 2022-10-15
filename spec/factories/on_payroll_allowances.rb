FactoryBot.define do
  factory :on_payroll_allowance do
    employee { nil }
    amount { "9.99" }
    name { "MyText" }
    payroll { nil }
  end
end
