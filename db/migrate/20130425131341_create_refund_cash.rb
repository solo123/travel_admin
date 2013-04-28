class CreateRefundCash < ActiveRecord::Migration
  def change
    create_table :refund_cashes do |t|
      t.integer :payment_id
      t.decimal :refund_amount, :precision => 8, :scale => 2
      t.decimal :refund_fee, :precision => 8, :scale =>2, :default => 0
      t.decimal :amount, :precision => 8, :scale => 2, :default => 0
      t.integer :received_by_id
      t.integer :account_id
      t.integer :status, :default => 0
      t.timestamps
    end
  end
end
