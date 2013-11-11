class UsersController < ApplicationController
  def index
    @users = User.order("created_at DESC")
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user]) 
    if @user.save
      twilio_sid = ENV["TWILIO_SID"]
      twilio_token = ENV["TWILIO_TOKEN"]
      @twilio_client = Twilio::REST::Client.new twilio_sid, twilio_token

      @users = User.order("created_at ASC")
      new_user = @users.pop
      new_user_mobile = new_user.mobile
      new_user_name = new_user.firstName

      @account = @twilio_client.account
      @message = @account.sms.messages.create({
        :from => '+14695027613',
        :to => new_user_mobile,
        :body => "Hey #{new_user_name}! Thanks for joining FootySubs. The app will be available soon and you'll be the first to know. Please tell your friends :)"
      })
      redirect_to '/signup/success'
    else
      flash.now[:error] = 'Could not complete sign up. Please try again.'
      render 'signup/new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])
    if @user.save
      flash.now[:message] = 'Your profile has been updated.'
      render 'edit'
    else
      flash.now[:error] = 'Please try again. Your profile was not updated.'
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    if current_user.id == 1
      redirect_to events_path
    else
      redirect_to users_path
    end
  end

  def show
    @user = User.find(params[:id])
    @events = Event.order("start DESC")
    @open = Event.where(:status => "open").order("start ASC")
    @full = Event.where(:status => "full").order("start ASC")
  end
end
