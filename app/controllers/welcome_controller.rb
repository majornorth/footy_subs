class WelcomeController < ApplicationController
	def index
	    iron_worker = IronWorkerNG::Client.new
	    iron_worker.tasks.create("hello", "foo"=>"bar")
	end
end
