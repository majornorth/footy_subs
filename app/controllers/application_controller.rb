class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  require 'iron_worker_ng'
  require 'uber_config'
  require 'twilio-ruby'

  def index
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
  	    :body => "A sub is needed for a soccer match."
  	    })
  	end
  end

  # Force signout to prevent CSRF attacks
  def handle_unverified_request
    sign_out
    super
  end
end
