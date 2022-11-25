class ActivitiesController < ApplicationController
  def homepage
    @categories = Category.all
    @activities = Activity.first(3)
    if params[:query].present?
      yield @activities = Activity.search_by_activity(params[:query])
    else
      @activities = Activity.all
    end
  end

  def index
    @activities = Activity.all
    @categories = Category.all
  end

  def show
    @activity = Activity.find(params[:id])
    @bookmark = Bookmark.new

    @markers = [{
      lat: @activity.latitude,
      lng: @activity.longitude
    }]
  end
end
