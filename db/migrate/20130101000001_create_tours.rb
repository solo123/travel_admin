class CreateTours < ActiveRecord::Migration
  def change
    create_table :tours do |t|
    	t.integer :days, :default => 0
    	t.integer :tour_type, :default => 0
    	t.integer :title_photo_id
    	t.integer :status, :default => 0
    	t.timestamps
    end
    create_table :tour_prices do |t|
      t.integer :tour_id
      t.decimal :price_adult, :precision => 8, :scale => 2
      t.decimal :price_child, :precision => 8, :scale => 2
      t.decimal :price1, :precision => 8, :scale => 2
      t.decimal :price2, :precision => 8, :scale => 2
      t.decimal :price3, :precision => 8, :scale => 2
      t.decimal :price4, :precision => 8, :scale => 2
      t.timestamps
    end
    create_table :tour_settings do |t|
      t.integer :tour_id
      t.integer :is_auto_gen, :default => 0
      t.string :weekly
      t.integer :has_seat_table, :default => 0
      t.integer :is_float_price, :default => 0
      t.integer :days_in_advance, :default => 0
      t.datetime :last_schedule_date
      t.timestamps
    end  
    create_table :tour_routes do |t|
    	t.integer :tour_id
    	t.integer :destination_id
    	t.integer :visit_day
      t.integer :visit_order
    	t.integer :status, :default => 0
    	t.timestamps
    end
  	create_table :destinations do |t|
    	t.integer :city_id
    	t.integer :title_photo_id
      t.string :tag_name
    	t.integer :status
    	t.timestamps
    end
		create_table :schedules do |t|
    	t.integer :tour_id
    	t.string :title
    	t.date :departure_date
    	t.date :return_date
      t.integer :book_customers
      t.integer :actual_customers
      t.integer :actual_rooms
    	t.integer :status, :default => 0
    	t.timestamps
    end
    create_table :schedule_prices do |t|
      t.integer :schedule_id
      t.decimal :price_adult, :precision => 8, :scale => 2
      t.decimal :price_child, :precision => 8, :scale => 2
      t.decimal :price1, :precision => 8, :scale => 2
      t.decimal :price2, :precision => 8, :scale => 2
      t.decimal :price3, :precision => 8, :scale => 2
      t.decimal :price4, :precision => 8, :scale => 2
      t.timestamps
    end
    create_table :schedule_assignments do |t|
      t.string :title
      t.integer :schedule_id
      t.integer :bus_id
      t.integer :driver_id
      t.integer :driver_assistance_id
      t.integer :tour_guide_id
      t.integer :tour_guide_assistance_id
      t.timestamps
    end
    create_table :schedule_assignment_costs do |t|
      t.integer :schedule_assignment_id
      t.integer :cost_type
      t.decimal :amount, :precision => 8, :scale => 2, :default => 0 
      t.integer :edit_by
      t.timestamps
    end
    create_table :schedule_assignment_balances do |t|
      t.integer :schedule_id
      t.integer :schedule_assignment_id
      t.decimal :income, :precision => 8, :scale => 2, :default => 0
      t.decimal :cost, :precision => 8, :scale => 2, :default => 0
      t.decimal :balance, :precision => 8, :scale => 2, :default => 0
      t.timestamps
    end




  end

end
