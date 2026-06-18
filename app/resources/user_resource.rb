# frozen_string_literal: true

class UserResource < BaseResource
  attributes :id, :name, :email, :created_at, :updated_at

  # ユーザーが持つスキル一覧をネストして返す
  many :user_skills, resource: UserSkillResource
end
