# frozen_string_literal: true

# スキルのマスターデータを管理し、ユーザーとの関連付けや検証を行うモデル
class Skill < ApplicationRecord
  has_many :user_skills, dependent: :destroy
  has_many :users, through: :user_skills

  validates :name, presence: true, uniqueness: true
  validates :layer, presence: true
end
