class User < ApplicationRecord
  include ActiveModel::Serializers::JSON
  has_secure_password
  belongs_to :company
  has_one :session_record
  has_many :device_session_records
  has_many :user_page_accesses
  has_many :user_page_action_accesses

  validates :email,
            format: { with: URI::MailTo::EMAIL_REGEXP },
            presence: true,
            uniqueness: { case_sensitive: false }

  enum status: { A: "A", I: "I"}

  # def attributes
  #   { id: id, email: email, position: position, name: name, company_id: company_id, hr_head: hr_head }
  # end

  def generate_password_token!
    begin
      self.reset_password_token = SecureRandom.urlsafe_base64
    end while User.exists?(reset_password_token: self.reset_password_token)
    self.reset_password_token_expires_at = 1.day.from_now
    save!
  end

  def clear_password_token!
    self.reset_password_token = nil
    self.reset_password_token_expires_at = nil
    save!
  end
end
