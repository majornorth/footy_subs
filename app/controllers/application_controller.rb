class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  def index
  	iron_worker = IronWorkerNG::Client.new
  	iron_worker.tasks.create("hello", "foo"=>"bar")
  end

  # Force signout to prevent CSRF attacks
  def handle_unverified_request
    sign_out
    super
  end
end
