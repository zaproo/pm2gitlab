# OpenProject Gitlab Plugin (Latest supported version: 7.4.4)

[OpenProject](https://www.openproject.org) plugin makes integration with [Gitlab](https://gitlab.com):
- creates Merge Request on changing task status to defined as 'merger request' (you can define trigger task by your own)
- sends message to OpenProject after Merge Request in GinLab merged to master

Branch in GitLab should looks like:
```
:branchname_:taskid
```
e.g. `mybranch_12`, `dev_1234`, etc.

taskid - used to find corresponded work package in OpenProject.

## Install

To include the new plugin into OpenProject, you have to add it into Gemfile.plugins like any other OpenProject plugin.

```
group :opf_plugins do
  gem "openproject-pm2gitlab", git: "https://github.com/zaproo/pm2gitlab.git", :branch => "master"
end
```

After that run
```
bundle install
rake db:migrate
```

More information about OpenProject plugins you can get [here](https://www.openproject.org/open-source/development-free-project-management-software/create-openproject-plugin/).

After installing plugin go to administration plugins page and set up your base gitlab url, access token, tokens for incoming hooks and openproject to gitlab user map table. You should also fill in specific settings for each project.

## Incoming hooks (use POST method for all hooks)
- sends message to task after Merge Request merged to master in GitLab
```
http://[your-openproject-domain]/pm2gitlab/merge_request
```
