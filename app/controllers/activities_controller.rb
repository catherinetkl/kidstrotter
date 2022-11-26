class ActivitiesController < ApplicationController
  def homepage
    @categories = Category.all
    @activities = Activity.first(3)
    if params[:query].present?
      yield @activities = Activity.search_by_activity(params[:query])
    else
      @activities = Activity.all
    end
  end

  def index
    @activities = Activity.all
    @categories = Category.all
  end

  def show
    @activity = Activity.find(params[:id])
    @activities = Activity.requested_to(current_user)
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
    @activity = current_user.activities.build(activity_params)
    debugger
    if @activity.save!
      redirect_to root_path
      flash[:alert] = 'Activity has been created successfully!'
    else
      render 'activities/show', status: :unprocessable_entity
    end
  end

  def dates
    # Scope your query to the dates being shown:
    start_time = params.fetch(:start_time, Date.today).to_date

    # For a monthly view:
    @bookings = Booking.where(starts_at: start_time.beginning_of_month.beginning_of_week..start_time.end_of_month.end_of_week)

    # Or, for a weekly view:
    @bookings = Booking.where(starts_at: start_time.beginning_of_week..start_time.end_of_week)
  end

  def multi_days?
    (end_time.to_date - start_time.to_date).to_i >= 1
  end

  private

  def activity_params
    params.require(:activity).permit(:name, :description, :address, :start_time, :end_time, :adult_price, :child_price, :age_group, :user_id, :photo)
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
