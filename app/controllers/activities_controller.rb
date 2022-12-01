class ActivitiesController < ApplicationController
  before_action :set_activity, only: %i[show favorite unfavorite]

  def homepage
    @categories = Category.all
    @activities = Activity.all
  end

  def favorite
    # find the activity
    # favourite the activity with current user
    current_user.favorite(@activity)

    respond_to do |format|
      format.html { redirect_to activities_path }
      format.text { render partial: 'bookmark', formats: :html, locals: { current_user: current_user, activity: @activity }}
    end
  end

  def unfavorite
    # find the activity
    # unfavourite the activity with current user
    current_user.unfavorite(@activity)

    respond_to do |format|
      format.html { redirect_to params[:page] == 'bookmarks' ? bookmarks_path : activities_path }
      format.text { render partial: 'bookmark', formats: :html, locals: { current_user: current_user, activity: @activity }}
    end

    # Bookmark.destroy(params[:id]) #cant find the id after the first deleted due to unique
  end

  def index
    @categories = Category.all
    @activities = Activity.all

    @activities = Activity.near([params["lat"].to_f, params["lon"].to_f], 10) if params["lat"] && params["lon"]

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

    respond_to do |format|
      format.html
      format.json
    end
  end

  def organizer_index
    @activities = Activity.where(organizer: current_user.organizer)
  end

  def show
    @bookmark = Bookmark.new

    @markers = [{
      lat: @activity.latitude,
      lng: @activity.longitude
    }]
  end

  def new
    @activity = Activity.new
  end

  def create
    @categories = Category.all
    @activity = Activity.create(activity_params)
    @activity.organizer = current_user.organizer

    if @activity.save!
      redirect_to root_path
      flash[:alert] = 'Activity has been created successfully!'
    else
      render 'activities/show', status: :unprocessable_entity
    end
  end

  private

  def set_activity
    @activity = Activity.find(params[:id])
  end

  def activity_params
    params.require(:activity).permit(:name, :description, :address, :adult_price, :child_price, :age_group, :category_id, :photo,)
  end

  def authenticate
    if current_user
      ''
    else
      redirect_to new_user_session_path
      flash[:alert] = 'You must be signed in to do this.'
    end
  end
end
