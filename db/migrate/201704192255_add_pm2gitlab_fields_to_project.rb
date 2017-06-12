class AddPm2gitlabFieldsToProject < ActiveRecord::Migration
  def up
    add_column :projects, :pm2gitlab_project, :string
    add_column :projects, :pm2gitlab_target_branch, :string
  end

  def down
    remove_column :projects, :pm2gitlab_project
    remove_column :projects, :pm2gitlab_target_branch
  end
end
