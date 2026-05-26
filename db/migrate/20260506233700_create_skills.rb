# frozen_string_literal: true

class CreateSkills < ActiveRecord::Migration[7.2]
  def change
    create_table(:skills) do |t|
      t.string(:name)
      t.string(:layer)
      t.integer(:rating)

      t.timestamps
    end
  end
end
