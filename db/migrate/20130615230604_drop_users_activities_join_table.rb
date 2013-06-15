class DropUsersActivitiesJoinTable < ActiveRecord::Migration
  def change
  	drop_table :activities_users
  end
end
