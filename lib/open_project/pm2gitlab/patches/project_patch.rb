require_dependency 'project'

module OpenProject::Pm2gitlab::Patches::ProjectPatch
  def self.included(base)
    base.class_eval do
      belongs_to :pm2gitlab_assignee, class_name: 'User'
      belongs_to :pm2gitlab_status, class_name: 'Status'
    end
  end
end

Project.send(:include, OpenProject::Pm2gitlab::Patches::ProjectPatch)
