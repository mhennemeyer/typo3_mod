class AddSignedClaToUser < ActiveRecord::Migration
  def change
    add_column :users, :signed_cla, :boolean
  end
end
