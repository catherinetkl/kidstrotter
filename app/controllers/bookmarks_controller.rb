class BookmarksController < ApplicationController
  def index
    @bookmarks = Bookmark.where(user: current_user)
  end

  def create
    bookmark = Bookmark.new
    bookmark.user = current_user
    bookmark.activity = Activity.find(params[:activity_id])
    bookmark.save!
    redirect_to bookmarks_path
  end
end
