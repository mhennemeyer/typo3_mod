class AddSaltedPasswordToUser < ActiveRecord::Migration
  def change
    add_column :users, :salted_password, :string
  end
end
