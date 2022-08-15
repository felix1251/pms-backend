FactoryBot.define do
  factory :support_chat do
    encrypted_message { "MyText" }
    encrypted_message_iv { "MyText" }
    encrypted_message_salt { "MyString" }
    user_id { "" }
    admin_id { "" }
  end
end
