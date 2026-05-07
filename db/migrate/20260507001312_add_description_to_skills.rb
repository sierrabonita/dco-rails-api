class AddDescriptionToSkills < ActiveRecord::Migration[7.2]
  def change
    add_column :skills, :description, :text
  end
end
