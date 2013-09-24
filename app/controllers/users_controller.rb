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
      sign_in @user
      redirect_to events_path
    else
      render 'new'
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
    redirect_to users_path
  end

  def show
    @user = User.find(params[:id])
    @events = Event.order("start DESC")
    @open = Event.where(:status => "open").order("start ASC")
    @full = Event.where(:status => "full").order("start ASC")
  end
end
