# frozen_string_literal: true

class AddCheckConstraintToUserSkillsRating < ActiveRecord::Migration[7.2]
  def change
    add_check_constraint(:user_skills, 'rating >= 1 AND rating <= 5', name: 'check_user_skills_rating_range')
  end
end
