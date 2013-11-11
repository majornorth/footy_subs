class SignupController < ApplicationController
	def new
		@user = User.new
	end
end
