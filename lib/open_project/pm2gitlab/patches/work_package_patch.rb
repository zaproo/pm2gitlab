require_dependency 'work_package'

module OpenProject::Pm2gitlab::Patches::WorkPackagePatch
  def self.included(base)
    base.class_eval do
      include InstanceMethods

      after_save :pm2gitlab_event_notification, if: :notification_allowed?
    end
  end

  module InstanceMethods
    def pm2gitlab_event_notification
      Redmine::Hook.call_hook(
        :pm2gitlab_event_notification,
        { journal: self.current_journal }
      )
      true
    end

    def notification_allowed?
      OpenProject::Pm2gitlab::Engine.enabled? &&
      project.pm2gitlab_project.present? &&
      project.pm2gitlab_target_branch.present? &&
      current_journal.present? &&
      status_id_changed? &&
      status == ( project.pm2gitlab_status.presence || Status.where(name: 'merger request').first )
    end
  end
end

WorkPackage.send(:include, OpenProject::Pm2gitlab::Patches::WorkPackagePatch)
