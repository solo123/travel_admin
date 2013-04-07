class CreateTodos < ActiveRecord::Migration
  def change
    create_table :todos do |t|
      t.integer :employee_info_id
      t.string :message
      t.integer :level
      t.integer :status
      t.datetime :due_date
      t.timestamps
    end
    create_table :todo_workers do |t|
      t.integer :todo_id
      t.integer :employee_info_id
      t.integer :role
      t.timestamps
    end
  end
end
