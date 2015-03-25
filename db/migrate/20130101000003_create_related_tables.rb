class CreateRelatedTables < ActiveRecord::Migration
  def change
    create_table :ads do |t|
      t.string :url
      t.string :image_type
      t.integer :status, :default => 0
      t.timestamps
    end
    create_table :photos do |t|
      t.string :photo_data_type
      t.integer :photo_data_id
      t.integer :created_by
      t.integer :bytes
      t.string :url
      t.string :public_id
      t.string :thumbnail_url

      t.timestamps
    end
    create_table :preferences, :force => true do |t|
      t.string :key
      t.string :value_type
      t.string :name
      t.integer :owner_id
      t.string :owner_type
      t.integer :group_id
      t.string :group_type
      t.text   :value
      t.timestamps
    end
    add_index :preferences, :key, :unique => true

    create_table :pages do |t|
      t.string :title
      t.string :permalink
      t.string :meta_keywords
      t.string :meta_description
      t.integer :status, :default => 0
      t.timestamps
    end
    create_table :descriptions do |t|
    	t.string :desc_data_type
    	t.integer :desc_data_id
      t.string :title
      t.string :title_cn
    	t.text :en
    	t.text :cn
    	t.timestamps
    end
    create_table :remarks do |t|
      t.string :note_data_type
      t.integer :note_data_id
      t.string :note_text
      t.integer :employee_info_id
      t.integer :status, :default => 0
      t.timestamps
    end
  	create_table :bookmarks do |t|
  		t.string :title
  		t.string :url
  		t.integer :show_order, :default => 0
  		t.integer :status, :default => 0
  		t.timestamps
  	end
    create_table :input_types do |t|
      t.string :type_name
      t.string :type_text
      t.string :type_value
      t.integer :status, :default => 0
      t.timestamps
    end
    create_table :telephones do |t|
      t.string :tel_number_type
      t.integer :tel_number_id
      t.string :tel_type
      t.string :tel
      t.integer :priority, :default => 0
      t.timestamps
    end
    create_table :emails do |t|
      t.string :email_data_type
      t.integer :email_data_id
      t.string :email_address
      t.integer :priority, :default => 0
      t.timestamps
    end
    create_table :addresses do |t|
      t.string :address_data_type
      t.integer :address_data_id
      t.string :address1
      t.string :address2
      t.string :zipcode
      t.integer :city_id
      t.integer :usage_type
      t.integer :priority, :default => 0
      t.timestamps
    end
    create_table :cities do |t|
      t.string :city
      t.string :state
      t.string :country
      t.integer :status, :default => 0
    end

  end

end
