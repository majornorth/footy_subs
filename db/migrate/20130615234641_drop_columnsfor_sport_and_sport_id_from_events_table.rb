class DropColumnsforSportAndSportIdFromEventsTable < ActiveRecord::Migration
  def change
  	remove_column :events, :sport
  	remove_column :events, :sport_id
  end
end
