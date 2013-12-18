class RenameOrganizerToOrganizerId < ActiveRecord::Migration
  change_table :events do |t|
    t.rename :organizer, :organizer_id
  end
end

