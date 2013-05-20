class AddStateToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :state, :string
    add_column :addresses, :country, :string
  end
end
