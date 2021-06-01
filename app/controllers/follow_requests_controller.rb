class FollowRequestsController < ApplicationController
  def index
    matching_follow_requests = FollowRequest.all

    @list_of_follow_requests = matching_follow_requests.order({ :created_at => :desc })

    render({ :template => "follow_requests/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_follow_requests = FollowRequest.where({ :id => the_id })

    @the_follow_request = matching_follow_requests.at(0)

    render({ :template => "follow_requests/show.html.erb" })
  end

  def create
    the_follow_request = FollowRequest.new
    the_follow_request.sender_id = @current_user.id
    recipient_id = params.fetch("query_recipient_id")
    the_follow_request.recipient_id = recipient_id
    
   recipient = User.where({:id => recipient_id}).first
    if recipient.private == false
     the_follow_request.status = "accepted"
    else
     the_follow_request.status = "pending"
    end

    the_follow_request.save

    if the_follow_request.status == "accepted"
     
      redirect_to("/users/#{recipient.username}", { :notice => "Follow request created successfully." })
    else
      redirect_to("/", { :notice => "Follow request failed to create successfully." })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_follow_request = FollowRequest.where({ :id => the_id }).at(0)

    the_follow_request.sender_id = params.fetch("query_sender_id")
    the_follow_request.recipient_id = params.fetch("query_recipient_id")
    the_follow_request.status = params.fetch("query_status")

    if the_follow_request.valid?
      the_follow_request.save
      redirect_to("/users/#{the_follow_request.recipient.username}", { :notice => "Follow request updated successfully."} )
    else
      redirect_to("/users/#{the_follow_request.recipient.username}", { :alert => "Follow request failed to update successfully." })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_follow_request = FollowRequest.where({ :id => the_id }).at(0)
    receiver = the_follow_request.recipient
    recipient_username = receiver.username
    recipient_private = receiver.private
    the_follow_request.destroy

    if recipient_private == true
      redirect_to("/")
    else
      redirect_to("/users/#{recipient_username}")
    end
  end
end
