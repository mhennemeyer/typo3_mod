class AddTopBarBackgroundColorToProject < ActiveRecord::Migration
  def change
    add_column :projects, :topbarbackgroundcolor, :string
  end
end
