class Pm2gitlabEvent < ActiveRecord::Base
  belongs_to :journal

  validates_presence_of :journal
end
