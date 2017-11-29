class IncomingHooksController < ActionController::Base
  before_action :authentificate_gitlab
  before_action :find_and_authorize_current_user
  before_action :find_work_package

  MERGE_REQUEST_X_GITLAB_EVENT_HEADER = 'Merge Request Hook'.freeze
  MERGE_REQUEST_TARGET_BRANCH         = 'master'.freeze
  MERGE_REQUEST_STATE                 = 'merged'.freeze

  def merge_request
    return unless authentificate_gitlab

    @work_package.add_journal(@user, merge_request_message)

    if @work_package.save
      head :ok
    else
      head :unprocessable_entity
    end
  end

  def merge_request_message
<<-EOS
Branch #{object_attributes_value(:source_branch)} has been merged to master \
and changes will be available on production server on next deployment.
See #{object_attributes_value(:url)} for details.
EOS
  end

  private

  def object_attributes_value(key)
    params[:object_attributes] && params[:object_attributes][key]
  end

  def authentificate_gitlab
    settings = Setting["plugin_openproject_pm2gitlab"]
    tokens = settings["pm2gitlab_incoming_hooks_tokens"]&.split

    is_valid = request.headers["X-Gitlab-Event"] == MERGE_REQUEST_X_GITLAB_EVENT_HEADER &&
               tokens&.include?(request.headers["X-Gitlab-Token"]) &&
               object_attributes_value(:target_branch) == MERGE_REQUEST_TARGET_BRANCH &&
               object_attributes_value(:state) == MERGE_REQUEST_STATE

    head(:unprocessable_entity) unless is_valid
    is_valid
  end

  def find_work_package
    work_package_id = object_attributes_value(:source_branch)&.split('_').last

    @work_package = WorkPackage.where(id: work_package_id).first if work_package_id

    head(:unprocessable_entity) unless @work_package.present?
    @work_package.present?
  end

  def find_and_authorize_current_user
    user_name = params[:user] && params[:user][:username]
    @user = Pm2gitlabUser.where(name: user_name).first&.user
    is_valid = @user && @user.status != 3
    if is_valid
      User.current = @user
    else
      head :unprocessable_entity
    end
    is_valid
  end
end
