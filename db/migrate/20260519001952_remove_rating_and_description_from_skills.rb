# frozen_string_literal: true

class RemoveRatingAndDescriptionFromSkills < ActiveRecord::Migration[7.2]
  def change
    remove_column(:skills, :rating, :integer)
    remove_column(:skills, :description, :text)
  end
end
