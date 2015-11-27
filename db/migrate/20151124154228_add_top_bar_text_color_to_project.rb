class AddTopBarTextColorToProject < ActiveRecord::Migration
  def change
    add_column :projects, :topbartextcolor, :string
  end
end
