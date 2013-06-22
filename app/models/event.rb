class Event < ActiveRecord::Base
  attr_accessible :needed, :start, :location, :league, :skill_level, :field_type, :organizer, :note, :status
  has_and_belongs_to_many :users
end
