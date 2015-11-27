class AddSortingToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :sorting, :integer
  end
end
