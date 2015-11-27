class AddImgHashToUser < ActiveRecord::Migration
  def change
    add_column :users, :img_hash, :string
  end
end
