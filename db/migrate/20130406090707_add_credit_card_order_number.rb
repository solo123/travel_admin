class AddCreditCardOrderNumber < ActiveRecord::Migration
  def change
    add_column :pay_credit_cards, :order_id, :integer
    add_column :pay_credit_cards, :issue_date, :string
    add_column :pay_credit_cards, :issue_number, :string
  end
end
