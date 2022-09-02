class User < ApplicationRecord
  include ActiveModel::Serializers::JSON
  has_secure_password
  belongs_to :company
  has_one :session_record
  has_many :device_session_records
  has_many :user_page_accesses
  has_many :user_page_action_accesses
  has_many :employee_action_histories
  has_many :employees, foreign_key: :created_by_id
  has_many :job_classification, foreign_key: :created_by_id

  validates :email, allow_blank: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP , :message => "email format is invalid"}
  validates :username, presence: true, uniqueness: { scope: :company_id }, format: { without: /\s/ , message: 'cannot contain whitespace' }
  validates :position, presence: true
  validates :name, presence: true
  enum status: { A: "A", I: "I"}

  def attributes
    super.except('password_digest', 'reset_password_token', 'reset_password_token_expires_at')
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
