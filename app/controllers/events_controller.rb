class EventsController < ApplicationController
  def index
    @events = Event.order("start DESC")
    @open = Event.where(:status => "open").order("start ASC")
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(params[:event]) 
    @event.save
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