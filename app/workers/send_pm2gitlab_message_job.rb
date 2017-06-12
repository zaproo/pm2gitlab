require 'net/http'
require 'net/https'

class SendPm2gitlabMessageJob < ApplicationJob
  include OpenProject::StaticRouting::UrlHelpers

  def initialize(event)
    @event = event
    @journal = @event.journal
    @work_package = @journal.journable
    @project = @journal.project
  end

  def perform
    return unless gitlab_branch_exists?
    uri = URI.parse("#{base_url}/projects/#{gitlab_project_id}/merge_requests")
    req = http_request(uri, 'Post')
    req.set_form_data(
      source_branch: branch_name,
      target_branch: @project.pm2gitlab_target_branch,
      title: @work_package.subject,
      id: @project.pm2gitlab_project.split('/').last,
      assignee_id: gitlab_user_id(@project.pm2gitlab_assignee)
    )
    http_response(uri, req)
  end

  def success(job)
    @event.destroy
  end

  protected def default_url_options
    {
      host: OpenProject::StaticRouting::UrlHelpers.host,
      only_path: false,
      script_name: OpenProject::Configuration.rails_relative_url_root
    }
  end

  private def branch_name
    "task_#{@work_package.id}"
  end

  private def gitlab_branch_exists?
    return unless @project.pm2gitlab_target_branch.present?
    uri = URI.parse("#{base_url}/projects/#{gitlab_project_id}/repository/branches/#{branch_name}")
    req = http_request(uri)
    res = http_response(uri, req)
    branch_json = JSON.parse(res.body)
    branch_json['name'].present?
  end

  private def gitlab_user_id(user)
    return unless user.present?
    uri = URI.parse("#{base_url}/users")
    req = http_request(uri)
    req.set_form_data(username: user.pm2gitlab_user.name)
    res = http_response(uri, req)
    user_json = JSON.parse(res.body)[0]
    user_json['id'] if user_json
  end

  private def gitlab_project_id
    URI.encode(@project.pm2gitlab_project, /\W/)
  end

  private def base_url
    "#{Setting.plugin_openproject_pm2gitlab[:pm2gitlab_url]}/api/#{api_version}"
  end

  private def api_version
    'v4'
  end

  private def http_request(uri, method = 'Get')
    "Net::HTTP::#{method}".constantize.new(uri.request_uri).tap do |req|
      req['PRIVATE-TOKEN'] = Setting.plugin_openproject_pm2gitlab[:pm2gitlab_token]
    end
  end

  def http_response(uri, request)
    Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.instance_of?(URI::HTTPS)) do |http|
      http.request(request)
    end
  end
end
