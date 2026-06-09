# frozen_string_literal: true

class UserSkill < ApplicationRecord
  belongs_to :user
  belongs_to :skill

  validates :skill_id, uniqueness: { scope: :user_id }
  validates :rating, inclusion: { in: 1..5 }, allow_nil: true
end
