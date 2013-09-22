class EventsController < ApplicationController
  def index
    @events = Event.order("start DESC") 
    @joined = Event.order("start ASC")
    @open = Event.where(:status => "open").order("start ASC")
    @full = Event.where(:status => "full").order("start ASC")
    @ended = Event.where(:status => "ended").order("start DESC")
    @all_events = Event.find(:all)
    @all_events.each do |e|
      if e.start < Time.now
        e.update_attributes(:status => "ended")
      end
    end
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(params[:event]) 
    @event.save

    e_id = @event.id

    starts = @event.start

    twilio_sid = ENV["TWILIO_SID"]
    twilio_token = ENV["TWILIO_TOKEN"]
    @twilio_client = Twilio::REST::Client.new twilio_sid, twilio_token

    subscribers = User.all
    subscriber_numbers = Array.new
    subscribers.each do |s|
      subscriber_numbers.push(s.mobile)
    end

    subscriber_numbers.each do |number|
      @account = @twilio_client.account
      @message = @account.sms.messages.create({
        :from => '+14695027613',
        :to => number,
        :body => "A sub is needed for a soccer match happening #{starts.strftime("%A, %b %e at%l:%M%P")}. You can join here: footysubs.herokuapp.com#{event_path(e_id)}"
        })
    end

    redirect_to events_path
  end

  def edit
    @event = Event.find(params[:id])
    @attendees = @event.users
  end

  def update
    @event = Event.find(params[:id])
    @event.needed = params[:needed]
    @event.update_attributes(params[:event])
    redirect_to event_path
  end

  def destroy
    Event.find(params[:id]).destroy
    # need to destroy events_users joins
    redirect_to events_path
  end

  def show
    @event = Event.find(params[:id])
  end

  def join
    @add_user = Event.find(params[:event][:event_id]).users << current_user
    @attendees = Event.find(params[:event][:event_id]).users.count
    @needed = Event.find(params[:event][:event_id]).needed
    @event = Event.find(params[:event][:event_id])
    if @attendees == @needed
      @event.update_attributes(:status => "full")
    end
    redirect_to :back
  end

  def leave
    @event = Event.find(params[:event][:event_id]).users.delete(current_user)
    @attendees = Event.find(params[:event][:event_id]).users.count
    @needed = Event.find(params[:event][:event_id]).needed
    @event = Event.find(params[:event][:event_id])
    if @attendees < @needed
      @event.update_attributes(:status => "open")
    end
    redirect_to :back
  end
end