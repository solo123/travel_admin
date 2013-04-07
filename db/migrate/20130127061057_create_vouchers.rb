class CreateVouchers < ActiveRecord::Migration
  def change
    create_table :vouchers do |t|
      t.integer :payment_id
      t.integer :order_id      
      t.decimal :order_amount, :precision => 8, :scale => 2, :default => 0
      t.decimal :refund_fee, :precision => 8, :scale => 2, :default => 0
      t.decimal :amount, :precision => 8, :scale => 2, :default => 0
      t.date :expire_date
      t.integer :employee_info_id
      t.integer :status, :default => 0
      t.timestamps
    end
  end
end
