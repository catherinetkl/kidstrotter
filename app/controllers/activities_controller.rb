class ActivitiesController < ApplicationController
  def homepage
    @categories = Category.all
    @activities = Activity.first(3)
  end

  def index
    @activities = Activity.all
    @categories = Category.all

    if params[:query].present?
      @activities = Activity.search_by_activity_and_category(params[:query])

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

  def activity_params
    params.require(:activity).permit(:name, :description, :address, :adult_price, :child_price, :age_group, :category_id, :photo)
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
