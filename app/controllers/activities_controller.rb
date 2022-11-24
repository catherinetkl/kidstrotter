class ActivitiesController < ApplicationController
  def index
    @activities = Activity.all
    @categories = Category.all

    @markers = @activities.geocoded.map do |act|
      {
        lat: act.latitude,
        lng: act.longitude
      }
    end

    if params[:query].present?
      yield @activities = Activity.search_by_activity(params[:query])
    else
      @activities = Activity.all
    end
  end

  def show
    @activity = Activity.find(params[:id])
    @booking = Booking.new
    @bookmark = Bookmark.new
  end
end
