class DropTablePosts < ActiveRecord::Migration[7.2]
  def change
    t.string :name, null: false
    t.timestamps null: false
  end
end
