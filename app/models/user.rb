class User < ApplicationRecord
  has_secure_password
  has_many :posts, dependent: :destroy

  # Rails 7.1+ supports normalizing attributes with the `normalizes` method, but since we're using Rails 7.0, we can implement normalization with a callback instead.
  # normalizes :email, with: ->(email) { email.downcase }
  before_save :downcase_email

  validates :name, presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,
            presence: true,
            length: {
              maximum: 255
            },
            format: {
              with: VALID_EMAIL_REGEX
            },
            uniqueness: {
              case_sensitive: false
            }

  validates :password, presence: true, length: { minimum: 8 }, allow_nil: true

  private

  def downcase_email
    self.email = email.downcase
  end
end
