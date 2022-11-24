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
    @activities = Activity.all

    @activity = Activity.find(params[:id])
    @booking = Booking.new
    @bookmark = Bookmark.new

    @markers = @activities.geocoded.map do |act|
      {
        lat: act.latitude,
        lng: act.longitude
      }
    end
  end
end
