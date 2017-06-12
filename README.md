# OpenProject Gitlab Plugin

[OpenProject](https://www.openproject.org) plugin makes integration with [Gitlab](https://gitlab.com)

## Install

To include the new plugin into OpenProject, you have to add it into Gemfile.plugins like any other OpenProject plugin.

```
group :opf_plugins do
  gem "openproject-pm2gitlab", git: "https://git.zaproo.net/zaproo/pm2gitlab.git", :branch => "master"
end
```

After that run
```
bundle install
rake db:migrate
```

More information about OpenProject plugins you can get [here](https://www.openproject.org/open-source/development-free-project-management-software/create-openproject-plugin/).

After installing plugin go to administration plugins page and set up your base gitlab url, access token and openproject to gitlab map table. You should also fill in specific settings for each project.
