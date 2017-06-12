class Pm2gitlabUser < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user
end
