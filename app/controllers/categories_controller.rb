class CategoriesController < ApplicationController
  # before_action :set_category, only: %i[show]

  def index
    @categories = Category.all
    @activities = Activity.all
  end

  def show

    @category = Category.find(params[:id])
    @activities = @category.activities

    # @categories = Category.all
    # @activities = Activity.all

    # check if user searched for anything
    @activities = @activities.search_by_activity_and_category(params[:query]) if params[:query].present?
    # check if user filtered by price
    @activities = @activities.where(require_payment: params[:require_payment]) if params[:require_payment].present? && params[:require_payment] != 'all'
    # check if user filtered by categories
    @activities = @activities.where(category_id: params[:category].to_i) if params[:category].present?
    # check if user filtered by adult price
    if params[:adult_price].present?
      @activities = @activities.order(adult_price: :desc) if params[:adult_price] == "highest"
      @activities = @activities.order(adult_price: :asc) if params[:adult_price] == "lowest"
    end

    @markers = @activities.geocoded.map do |activity|
      {
        lat: activity.latitude,
        lng: activity.longitude
      }
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
    @map_activities = Activity.all
    @activities = @category.activities
    # @map_activities = Activity.all
  end
end
