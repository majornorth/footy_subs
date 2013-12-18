class EventsController < ApplicationController
  def index
    @events = Event.order("start DESC")
    @organized = Event.where(:organizer_id => current_user, :status => "open").order("start ASC")
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
        :body => "A sub is needed for a soccer match on #{starts.strftime("%A, %b %e at%l:%M%P")}. You can join here: footysubs.com/match/#{e_id}"
        })
    end

    redirect_to events_path
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    @event.needed = params[:needed]
    @event.update_attributes(params[:event])

    if @event.start > Time.now && @event.status != "full"
      @event.update_attributes(:status => "open")
    end

    e_id = @event.id

    starts = @event.start

    twilio_sid = ENV["TWILIO_SID"]
    twilio_token = ENV["TWILIO_TOKEN"]
    @twilio_client = Twilio::REST::Client.new twilio_sid, twilio_token

    subscribers = @event.users
    subscriber_numbers = Array.new
    subscribers.each do |s|
      subscriber_numbers.push(s.mobile)
    end

    subscriber_numbers.each do |number|
      @account = @twilio_client.account
      @message = @account.sms.messages.create({
        :from => '+14695027613',
        :to => number,
        :body => "The match you joined scheduled for #{starts.strftime("%A, %b %e at%l:%M%P")} has been updated. Details: footysubs.com/match/#{e_id}"
        })
    end

    redirect_to event_path
  end

  def destroy
    @event = Event.find(params[:id])
    e_id = @event.id

    starts = @event.start

    twilio_sid = ENV["TWILIO_SID"]
    twilio_token = ENV["TWILIO_TOKEN"]
    @twilio_client = Twilio::REST::Client.new twilio_sid, twilio_token

    subscribers = @event.users
    subscriber_numbers = Array.new
    subscribers.each do |s|
      subscriber_numbers.push(s.mobile)
    end

    subscriber_numbers.each do |number|
      @account = @twilio_client.account
      @message = @account.sms.messages.create({
        :from => '+14695027613',
        :to => number,
        :body => "Subs are no longer needed for the match on #{starts.strftime("%A, %b %e at%l:%M%P")}. Be sure to check other matches for opportunities to play: footysubs.com"
        })
    end

    @event.destroy
    # need to destroy events_users joins
    redirect_to events_path
  end

  def show
    @event = Event.find(params[:id])
    @comments = @event.comment_threads.order('created_at asc')
    @new_comment = Comment.build_from(@event, current_user, "")
    organizer_id = @event.organizer
    @organizer = User.find(organizer_id)
  end

  def join
    @add_user = Event.find(params[:event][:event_id]).users << current_user
    @attendees = Event.find(params[:event][:event_id]).users.count
    @needed = Event.find(params[:event][:event_id]).needed
    @event = Event.find(params[:event][:event_id])
    if @attendees == @needed
      @event.update_attributes(:status => "full")
    end

    e_id = @event.id
    starts = @event.start
    organizer_id = @event.organizer
    organizer_number = User.find(organizer_id).mobile

    twilio_sid = ENV["TWILIO_SID"]
    twilio_token = ENV["TWILIO_TOKEN"]
    @twilio_client = Twilio::REST::Client.new twilio_sid, twilio_token

    @account = @twilio_client.account
      @message = @account.sms.messages.create({
        :from => '+14695027613',
        :to => organizer_number,
        :body => "#{current_user.firstName} #{current_user.lastName} has joined as a sub for the match on #{starts.strftime("%A, %b %e at%l:%M%P")}. Match details: footysubs.com/match/#{e_id}"
        })

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

    e_id = @event.id
    starts = @event.start
    organizer_id = @event.organizer
    organizer_number = User.find(organizer_id).mobile

    twilio_sid = ENV["TWILIO_SID"]
    twilio_token = ENV["TWILIO_TOKEN"]
    @twilio_client = Twilio::REST::Client.new twilio_sid, twilio_token

    @account = @twilio_client.account
      @message = @account.sms.messages.create({
        :from => '+14695027613',
        :to => organizer_number,
        :body => "#{current_user.firstName} #{current_user.lastName} is no longer signed up as a sub for the match on #{starts.strftime("%A, %b %e at%l:%M%P")}. Match details: footysubs.com/match/#{e_id}"
        })

    redirect_to :back
  end
end