class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|
      t.integer :company_id
      t.timestamps
    end
  end
end
