class Event < ActiveRecord::Base
  attr_accessible :needed, :start, :location, :league, :skill_level, :field_type, :organizer_id, :note, :status
  acts_as_commentable
  has_and_belongs_to_many :users
  belongs_to :organizer, :class_name => 'User'
end
