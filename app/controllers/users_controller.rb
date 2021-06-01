class UsersController < ApplicationController
    skip_before_action(:force_user_sign_in, { :only => [:index] })
  
  def index 
    @users = User.all.order({:username => :asc})

    @requests = FollowRequest.where({:sender_id=>@current_user})        
    render({:template => "users/index.html.erb"})
  end

  def show
    the_username = params.fetch("path_username")
    matching_user = User.where({:username => the_username})
    @user = matching_user.at(0)

    @pending = @user.received_follow_requests.where({:status =>"pending"})

    @follow_exist = @user.received_follow_requests.where({:sender_id => @current_user})

    render({:template => "users/show.html.erb"})
  end
end