class WelcomeController < ApplicationController
	iron_worker = IronWorkerNG::Client.new
	iron_worker.tasks.create("hello", "foo"=>"bar")
end
