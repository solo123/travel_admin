class AddIndexToUsersSearch < ActiveRecord::Migration
  def change
    add_index :user_infos, :full_name
    add_index :telephones, :tel
    add_index :emails, :email_address
    add_index :addresses, :address1
    add_index :addresses, :address2
    add_index :addresses, :zipcode
    add_index :employee_infos, :nickname
  end
end
