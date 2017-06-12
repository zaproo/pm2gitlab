class AddMergerRequestStatus < ActiveRecord::Migration
  def up
    Status.find_or_create_by(name: 'merger request')
  end
end
