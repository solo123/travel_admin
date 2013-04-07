class CreateAppConfigurations < ActiveRecord::Migration
  def change
    create_table :app_configurations do |t|
      t.string :key
      t.string :title
      t.string :val
      t.integer :parent_id
      t.timestamps
    end
  end
end
