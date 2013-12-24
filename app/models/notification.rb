class Notification
  def self.send_comment event_id, current_user
    return unless event_id
    @event = Event.find event_id

    e_id = @event.id
    starts = @event.start

    twilio_sid = ENV["TWILIO_SID"]
    twilio_token = ENV["TWILIO_TOKEN"]
    @twilio_client = Twilio::REST::Client.new twilio_sid, twilio_token

    match_subs = @event.users.messageable
    match_organizer = @event.organizer
    subscriber_numbers = []
    match_subs.each do |s|
      subscriber_numbers.push(s.mobile)
    end
    subscriber_numbers.push match_organizer.mobile

    subscriber_numbers.each do |number|
      @account = @twilio_client.account
      @message = @account.sms.messages.create({
        :from => '+14695027613',
        :to => number,
        :body => "#{current_user.firstName} commented on the match you're in on #{starts.strftime("%A, %b %e at%l:%M%P")}. Read and reply: footysubs.com/match/#{e_id}"
        })
    end
  end
end