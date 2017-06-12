class AddPm2gitlabAssigneeIdToProject < ActiveRecord::Migration
  def up
    add_column :projects, :pm2gitlab_assignee_id, :integer, index: true
  end

  def down
    remove_column :projects, :pm2gitlab_assignee_id
  end
end
