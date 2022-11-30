class CategoriesController < ApplicationController
  def index
    @categories = Category.all
    @activities = Activity.all
  end

  def show
    @category = Category.find(params[:id])
    @activities = @category.activities
    @map_activities = Activity.all

    @markers = @map_activities.geocoded.map do |activity|
      {
        lat: activity.latitude,
        lng: activity.longitude
      }
    end
  end
end
