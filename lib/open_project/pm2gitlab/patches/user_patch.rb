require_dependency 'user'

module OpenProject::Pm2gitlab::Patches::UserPatch
  def self.included(base)
    base.class_eval do
      has_one :pm2gitlab_user
    end
  end
end

Project.send(:include, OpenProject::Pm2gitlab::Patches::UserPatch)
