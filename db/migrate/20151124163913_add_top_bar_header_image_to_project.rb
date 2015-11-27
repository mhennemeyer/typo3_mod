class AddTopBarHeaderImageToProject < ActiveRecord::Migration
  def change
    add_column :projects, :topbarheaderimage, :string
  end
end
