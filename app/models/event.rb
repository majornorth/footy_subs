class Event < ActiveRecord::Base
  attr_accessible :needed, :start, :location, :league, :skill_level, :field_type, :organizer_id, :note, :status
  acts_as_commentable
  has_and_belongs_to_many :users
  belongs_to :organizer, :class_name => 'User'


  def validate_year params
    submitted_year = params["event"]["start(1i)"]
    submitted_month = params["event"]["start(2i)"]
    submitted_day = params["event"]["start(3i)"]
    submitted_hour = params["event"]["start(4i)"]
    submitted_minutes = params["event"]["start(5i)"]

    actual_date = Time.now
    submitted_date = Time.new submitted_year, submitted_month, submitted_day

    if submitted_date < actual_date
      self.start = Time.new Time.now.year.next, submitted_month, submitted_day, submitted_hour, submitted_minutes
    end
  end

end
