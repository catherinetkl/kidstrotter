class BookmarksController < ApplicationController
  before_action :authenticate

  def index
    @bookmarks = Bookmark.where(user: current_user)
  end

  def new
    @activity = Activity.find(params[:activity_id])
    @bookmark = Bookmark.new
  end

  def show
  end

  def create
    @activity = Activity.find(params[:activity_id])

    @bookmark = Bookmark.new
    @bookmark.user = current_user
    @bookmark.activity = @activity

    if @bookmark.save
      redirect_to root_path
      flash[:alert] = 'Bookmark made successfully!'
    else
      render 'root_path', status: :unprocessable_entity
    end
  end

  def destroy
    Bookmark.destroy(params[:id])
    redirect_to bookmark
  end

  private

  def authenticate
    if current_user
      ''
    else
      redirect_to new_user_session_path
      flash[:alert] = 'You must be signed in to do this.'
    end
  end
end
