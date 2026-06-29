# frozen_string_literal: true

# ユーザーとスキルの紐付け（中間テーブル）およびその習熟度（rating）を管理するモデル
class UserSkill < ApplicationRecord
  belongs_to :user
  belongs_to :skill

  validates :skill_id, uniqueness: { scope: :user_id }
  validates :rating, numericality: { in: 1..5, only_integer: true, allow_nil: true }
end
