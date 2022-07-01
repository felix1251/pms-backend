class User < ApplicationRecord
  include ActiveModel::Serializers::JSON
  has_secure_password
  belongs_to :company

  serialize :address, Array
  validates :email,
            format: { with: URI::MailTo::EMAIL_REGEXP },
            presence: true,
            uniqueness: { case_sensitive: false }

  enum status: %i[A I].freeze

  def attributes
    { id: id, email: email, page_access_rigths: page_access_rigths, action_access_rigths: action_access_rigths, position: position, name: name}
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
