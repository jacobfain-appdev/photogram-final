class UsersController < ApplicationController
  def index 
    @users = User.all.order({:username => :asc})
    render({:template => "users/index.html.erb"})
  end

  def show
    the_username = params.fetch("path_username")
    matching_user = User.where({:username => the_username})
    @user = matching_user.at(0)
    render({:template => "users/show.html.erb"})
  end
end