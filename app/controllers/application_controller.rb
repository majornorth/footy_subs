class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  require 'twilio-ruby'
  require 'iron_worker_ng'
  require 'uber_config'

  def index
  	
  	begin
  	  @config = UberConfig.load()
  	  @params = @config
  	  @iw = IronWorkerNG::Client.new
  	rescue => ex
  	  @config = params
  	end

  	@iw.tasks.create("sms", @config)

  	twilio_sid = ENV["TWILIO_SID"]
  	twilio_token = ENV["TWILIO_TOKEN"]
  	@twilio_client = Twilio::REST::Client.new twilio_sid, twilio_token

  	subscriber_numbers = ['5157080626','4155156286']

  	subscriber_numbers.each do |number|
  	  r = @client.account.sms.messages.create({
  		  :from => from,
  		  :to => number,
  		  :body => "Hello from Stewart via Heroku and IronWorker!"
  	  })
  	end
  end

  # Force signout to prevent CSRF attacks
  def handle_unverified_request
    sign_out
    super
  end
end
