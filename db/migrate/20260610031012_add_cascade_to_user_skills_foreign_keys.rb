# frozen_string_literal: true

class AddCascadeToUserSkillsForeignKeys < ActiveRecord::Migration[7.2]
  def change
    remove_foreign_key :user_skills, :users
    remove_foreign_key :user_skills, :skills

    add_foreign_key :user_skills, :users, on_delete: :cascade
    add_foreign_key :user_skills, :skills, on_delete: :cascade
  end
end
