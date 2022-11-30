class ActivitiesController < ApplicationController
  before_action :set_activity, only: %i[show favorite unfavorite]

  def homepage
    @categories = Category.all
    @activities = Activity.first(3)
  end

  def favorite
    current_user.favorited?(@activity) ? current_user.unfavorite(@activity) : current_user.favorite(@activity)

    respond_to do |format|
      format.html { redirect_to activities_path }
      format.text { render partial: 'bookmark', formats: :html, locals: { current_user: current_user, activity: @activity }}
    end
  end

  def index
    @categories = Category.all
    @activities = Activity.all

    @activities = @activities.where(category_id: params[:category].to_i) if params[:category].present?
    # check if user searched for anything
    @activities = @activities.search_by_activity_and_category(params[:query]) if params[:query].present?
    # # check if user filtered by price
    @activities = @activities.where(require_payment: params[:require_payment]) if params[:require_payment].present? && params[:require_payment] != 'all'

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
