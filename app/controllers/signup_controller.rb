class SignupController < ApplicationController
	def new
		@user = User.new
	end

	def create
	  @user = User.new(params[:user]) 
	  if @user.save
	    redirect_to 'signup/success'
	  end
	end

	def success
		render 'signup/success'
	end
end
