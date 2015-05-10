class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :creator_id, index: true
			t.string :send_to
      t.integer :message_type
      t.string :message_title
      t.text :message_body
      t.references :reply_to_id, index: true
      t.integer :status, default: 0

      t.timestamps null: false
    end
		create_table :message_receipts do |t|
			t.integer :message_id, index: true
			t.integer :employee_info_id, index: true
			t.integer :status, default: 0

			t.timestamps null: false
	  end
		create_table :message_refs do |t|
			t.integer :message_id, index: true
			t.string :ref_title
			t.string :ref_url
			t.string :ref_type
			t.timestamps null: false
		end
  end
end
