# frozen_string_literal: true

class UserSkillResource < BaseResource
  attributes :id, :rating, :description, :created_at, :updated_at

  # Skill情報をネストして返す
  one :skill, resource: SkillResource
end
