class AddPm2gitlabUsers < ActiveRecord::Migration
  def change
    create_table :pm2gitlab_users do |t|
      t.belongs_to :user
      t.string :name

      t.timestamps null: false

      t.index [:user_id], unique: true
    end
  end
end
