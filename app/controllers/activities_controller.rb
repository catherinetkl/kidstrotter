class ActivitiesController < ApplicationController

  def landing
    @categories = Category.all

    @activities = Activity.first(3)
  end

  def index
    @categories = Category.all

    @activities = Activity.all
    @activities = Activity.search_by_activity(params[:query]) if params[:query].present?
  end

  def show
    @activity = Activity.find(params[:id])
    @booking = Booking.new
    @bookmark = Bookmark.new
  end
end
