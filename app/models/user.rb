# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_many :user_skills, dependent: :destroy
  has_many :skills, through: :user_skills

  before_save :downcase_email

  enum :role, { normal: 'normal', admin: 'admin' }

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

  validates :password,
            presence: true,
            length: {
              minimum: 8
            },
            allow_nil: true,
            if: -> { provider.blank? }

  scope :by_skills, lambda { |skill_ids|
    joins(:user_skills).where(user_skills: { skill_id: skill_ids }).distinct
  }

  scope :min_rating, lambda { |rating|
    joins(:user_skills).where(user_skills: { rating: rating.. }).distinct
  }

  scope :search_by_name, lambda { |keyword|
    where('name LIKE ?', "%#{keyword}%")
  }

  private

  def downcase_email
    self.email = email.downcase
  end
end
