class Pm2gitlabSettingsController < ApplicationController
  # this is necessary if you want the project menu in the sidebar for your view
  before_filter :find_optional_project, only: [:get_data, :update_data]

  def get_data
    @data = {}
    @data[:pm2gitlab_target_branch] = @project.pm2gitlab_target_branch
    @data[:pm2gitlab_assignee_id] = @project.pm2gitlab_assignee_id
    @data[:pm2gitlab_status_id] = @project.pm2gitlab_status_id
    @data[:users] = Principal.where(type: 'User').active.in_project(@project)
    @data[:statuses] = Status.all
    render 'pm2gitlab_settings/form'
  end

  def update_data
    update_settings
    flash[:notice] = l(:pm2gitlab_settings_updated_successfully)
    redirect_to action: :get_data, project_id: @project.id
  end

  def update_common_data
    Setting["plugin_openproject_pm2gitlab"] = params[:settings].permit!.to_h
    update_pm2gitlab_users
    flash[:notice] = l(:notice_successful_update)
    redirect_to "/settings/plugin/openproject_pm2gitlab"
  end

  private def update_settings
    data = params[:data]
    @project.pm2gitlab_target_branch = data[:pm2gitlab_target_branch]
    @project.pm2gitlab_assignee_id = data[:pm2gitlab_assignee_id]
    @project.pm2gitlab_status_id = data[:pm2gitlab_status_id]
    @project.save
  end

  private def update_pm2gitlab_users
    params[:pm2gitlab_users].map do |login, pm2gitlab_user|
      user = User.find_by(login: login)
      next unless user.present?
      Pm2gitlabUser.find_or_create_by(user: user).tap do |s|
        s.name = pm2gitlab_user[:name].try(:strip)
        s.save
      end
    end
  end
end
