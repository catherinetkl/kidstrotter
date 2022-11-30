class CategoriesController < ApplicationController
  before_action :set_category, only: %i[show]
  def index
    @categories = Category.all
    @activities = Activity.all
  end

  def show
    @activities = @category.activities

    # check if user searched for anything
    @activities = @activities.search_by_activity_and_category(params[:query]) if params[:query].present?
    # check if user filtered by price
    @activities = @activities.where(require_payment: params[:require_payment]) if params[:require_payment].present? &&
                                                                                  params[:require_payment] != 'all'
    end

  private

  def set_category
    @category = Category.find(params[:id])
    @map_activities = Activity.all

    @markers = @map_activities.geocoded.map do |activity|
      {
        lat: activity.latitude,
        lng: activity.longitude
      }
    end
  end
end
