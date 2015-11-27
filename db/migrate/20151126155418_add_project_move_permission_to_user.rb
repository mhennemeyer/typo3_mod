class AddProjectMovePermissionToUser < ActiveRecord::Migration
  def change
    add_column :users, :project_move_permission, :boolean
  end
end
