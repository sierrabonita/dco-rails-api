# frozen_string_literal: true

class AddUniqueIndexToSkillsName < ActiveRecord::Migration[7.2]
  def change
    add_index :skills, :name, unique: true
  end
end
