class CreateBusReservedDates < ActiveRecord::Migration
  def change
    create_table :bus_reserved_dates do |t|
      t.integer :bus_id
      t.date :from_date
      t.date :to_date
      t.string :reason
      t.timestamps
    end
  end
end
