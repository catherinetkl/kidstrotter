class ActivitiesController < ApplicationController
  def landing
    @categories = Category.all
    @activities = Activity.first(3)
  end

  def index
    @activities = Activity.all
    @categories = Category.all

    if params[:query].present?
      yield @activities = Activity.search_by_activity(params[:query])
    else
      @activities = Activity.all
    end
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
