class AddOrderAgent < ActiveRecord::Migration
  def change
    add_column :order_details, :from_agent_id, :integer
  end
end
