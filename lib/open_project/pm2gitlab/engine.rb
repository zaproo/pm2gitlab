# Prevent load-order problems in case openproject-plugins is listed after a plugin in the Gemfile
# or not at all
require 'open_project/plugins'

module OpenProject::Pm2gitlab
  class Engine < ::Rails::Engine
    engine_name :openproject_pm2gitlab

    include OpenProject::Plugins::ActsAsOpEngine

    def self.settings
      {
        default: { 'token'  => nil, 'base_url' => nil },
        partial: 'pm2gitlab_settings/common'
      }
    end

    def self.enabled?
      Setting.plugin_openproject_pm2gitlab[:pm2gitlab_url].present? &&
      Setting.plugin_openproject_pm2gitlab[:pm2gitlab_token].present?
    end

    def self.disabled?
      !self.enabled?
    end

    register(
      'openproject-pm2gitlab',
      author_url: 'https://openproject.org',
      requires_openproject: '>= 6.0.0',
      settings: settings
    ) do

      project_module :gitlab_settings do
        permission :update_pm2gitlab_settings, { pm2gitlab_settings: [:get_data, :update_data] }
      end

      menu :project_menu,
           :pm2gitlab_settings,
           { controller: :pm2gitlab_settings, action: :get_data },
           after: :settings,
           param: :project_id,
           caption: "Gitlab Settings",
           html: {
             class: 'icon2 icon-settings2 settings-menu-item ellipsis',
             id: "pm2gitlab-settings-menu-item"
           },
           if: ->(project) { true }
    end

    patches [:Project, :WorkPackage, :User]

    initializer 'pm2gitlab.register_hooks' do
      require 'open_project/pm2gitlab/hooks'
    end
  end
end
