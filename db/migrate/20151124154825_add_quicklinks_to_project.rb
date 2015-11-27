class AddQuicklinksToProject < ActiveRecord::Migration
  def change
    add_column :projects, :quicklinks, :text
  end
end
