class CategoriesController < ApplicationController
  def index
    @categories = Category.all
    @activities = Activity.all
  end

  def show
    @category = Category.find(params[:id])
    @activities = @category.activities
    # @map_activities = Activity.all

    @markers = @activities.geocoded.map do |event|
      {
        lat: event.latitude,
        lng: event.longitude
      }
    end
  end
end
