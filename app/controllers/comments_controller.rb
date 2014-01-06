class CommentsController < ApplicationController
  before_filter :view_application?

  def index
  end

	def create
	  @comment_hash = params[:comment]
	  @obj = @comment_hash[:commentable_type].constantize.find(@comment_hash[:commentable_id])
	  # Not implemented: check to see whether the user has permission to create a comment on this object
	  @comment = Comment.build_from(@obj, current_user, @comment_hash[:body])
	  if @comment.save
	    render :partial => "comments/comment", :locals => { :comment => @comment }, :layout => false, :status => :created
	  else
	  	raise @comment.errors.full_messages.inspect
	    render :js => "alert('error saving comment');"
	  end
    Notification.send_comment @comment.commentable_id, current_user
	end

	def destroy
      @comment = Comment.find(params[:id])
      if @comment.destroy
        render :json => @comment, :status => :ok
      else
        render :js => "alert('error deleting comment');"
      end
	end
end
