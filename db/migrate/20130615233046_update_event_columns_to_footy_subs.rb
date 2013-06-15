class UpdateEventColumnsToFootySubs < ActiveRecord::Migration
  def up
  	change_table :events do |t|
  		t.integer :needed, :default => 1
  		t.string :league
  		t.string :field_type
  		t.string :skill_level
  		t.text :note
  	end
  end

  def down
  	remove_column :events, :sport
  	remove_column :events, :sport_id
  end
end
