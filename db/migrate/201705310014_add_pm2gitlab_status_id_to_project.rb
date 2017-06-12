class AddPm2gitlabStatusIdToProject < ActiveRecord::Migration
  def up
    add_column :projects, :pm2gitlab_status_id, :integer, index: true
  end

  def down
    remove_column :projects, :pm2gitlab_status_id
  end
end
