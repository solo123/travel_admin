class CreateTransfers < ActiveRecord::Migration
  def change
    create_table :transfers do |t|
      t.integer :from_account_id, index: true
			t.integer :to_account_id, index: true
			t.decimal :amount, precision: 8, scale: 2, null: false
			t.belongs_to :employee_info, index: true
			t.integer :status, default: 0

      t.timestamps null: false
    end
  end
end
