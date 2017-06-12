module OpenProject::Pm2gitlab
  class Hooks < Redmine::Hook::Listener

    def pm2gitlab_event_notification(context = {})
      event = Pm2gitlabEvent.find_or_create_by(context)
      job = SendPm2gitlabMessageJob.new(event)
      Delayed::Job.enqueue(job, run_at: 5.seconds.from_now)
    end
  end
end
