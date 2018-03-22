# encoding: UTF-8
$:.push File.expand_path("../lib", __FILE__)

require 'open_project/pm2gitlab/version'
# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "openproject-pm2gitlab"
  s.version     = OpenProject::Pm2gitlab::VERSION
  s.authors     = "Zaproo"
  s.email       = "zaproo@zaproo.com"
  s.homepage    = "https://github.com/zaproo/pm2gitlab"
  s.summary     = 'OpenProject GitLab integration'
  s.description = "GitLab integration for OpenProject"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*"] + %w(CHANGELOG.md README.md)

  s.add_dependency "rails", "~> 5.0"
end
