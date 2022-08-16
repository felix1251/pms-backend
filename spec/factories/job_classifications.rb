FactoryBot.define do
  factory :job_classification do
    company_id { nil }
    description { "MyString" }
    created_by { 1 }
  end
end
