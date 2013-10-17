require 'twilio-ruby'
require 'active_record'
require_relative 'user'
require_relative 'event'

twilio_sid = params[:twilio_sid]
twilio_token = params[:twilio_token]
@twilio_client = Twilio::REST::Client.new twilio_sid, twilio_token

ActiveRecord::Base.establish_connection(
	:adapter => params[:adapter],
	:host => params[:host],
	:username => params[:username],
	:password => params[:password],
	:database => params[:database],
	:port => params[:port],
	)

events = Event.all
open_matches = Array.new
events.each do |event|
	if event.status == "open"
		open_matches.push(event)
	end
end
open_sorted = open_matches.sort_by { |e| e.start }
share_match = open_sorted.first
starts = share_match.start
e_id = share_match.id
organizer = share_match.organizer
organizer_mobile = User.find(organizer).mobile

subscribers = User.all
subscriber_numbers = Array.new
subscribers.each do |s|
  if s.mobile != organizer_mobile
    subscriber_numbers.push(s.mobile)
  end
end

subscriber_numbers.each do |number|
  @account = @twilio_client.account
  @message = @account.sms.messages.create({
    :from => '+14695027613',
    :to => number,
    :body => "A sub is needed for a soccer match happening on #{starts.in_time_zone("Pacific Time (US & Canada)").strftime("%A, %b %e at %l:%M%P")}. You can join here: footysubs.com/events/#{e_id}"
    })
end