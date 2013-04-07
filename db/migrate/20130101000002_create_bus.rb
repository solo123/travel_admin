class CreateBus < ActiveRecord::Migration
  def change
    create_table :buses do |t|
      t.string :name
      t.integer :company_id
      t.string :contact_name
      t.string :tel
      t.string :bus_type
      t.integer :seats
      t.integer :seats_per_row
      t.integer :passengeway
      t.string :reserved_seats
      t.string :plate_number
      t.string :vin_number
      t.date :inspection_date
      t.integer :title_photo_id
      t.integer :status, :default => 0
      t.timestamps
    end
    create_table :bus_seats do |t|
      t.integer :schedule_assignment_id
      t.integer :seat_number
      t.integer :order_id
      t.string :message
      t.string :customer_name
      t.string :telephone
      t.integer :operator_id
      t.string :state
      t.timestamps
    end  	
    create_table :bus_shifts do |t|
      t.integer :bus_id
      t.integer :schedule_assignment_id
      t.date :date
    end
    create_table :employee_shifts do |t|
      t.integer :employee_info_id
      t.integer :schedule_assignment_id
      t.date :date
    end
  end
end
