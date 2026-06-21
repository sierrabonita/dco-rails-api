# frozen_string_literal: true

class AddUniqueIndexToUserSkills < ActiveRecord::Migration[7.2]
  def change
    add_index :user_skills, %i[user_id skill_id], unique: true
  end
end
