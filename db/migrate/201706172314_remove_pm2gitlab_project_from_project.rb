class RemovePm2gitlabProjectFromProject < ActiveRecord::Migration
  def up
    remove_column :projects, :pm2gitlab_project
  end

  def down
    add_column :projects, :pm2gitlab_project, :string
  end
end
