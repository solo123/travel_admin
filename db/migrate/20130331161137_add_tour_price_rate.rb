class AddTourPriceRate < ActiveRecord::Migration
  def change
    add_column :tour_prices, :single_charge, :decimal, :precision => 8, :scale => 2, :default => 0
    add_column :tour_prices, :forth_charge, :decimal, :precision => 8, :scale => 2, :default => 0
    add_column :tour_prices, :buy_two_get_one_free, :integer, :default => 0
  end
end
