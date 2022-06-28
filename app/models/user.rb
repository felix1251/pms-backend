class User < ApplicationRecord
  include ActiveModel::Serializers::JSON
  has_secure_password

  serialize :address, Array
  validates :email,
            format: { with: URI::MailTo::EMAIL_REGEXP },
            presence: true,
            uniqueness: { case_sensitive: false }

  def attributes
    { id: id, email: email, page_access_rigths: page_access_rigths, action_access_rigths: action_access_rigths, fullname: fullname}
  end

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
