class AddPm2gitlabEvents < ActiveRecord::Migration
  def change
    create_table :pm2gitlab_events do |t|
      t.belongs_to :journal

      t.timestamps null: false
    end
  end
end
