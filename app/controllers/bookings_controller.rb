class BookingsController < ApplicationController
  before_action :authenticate

  def index
    @bookings = current_user.bookings.all
  end

  def show
    @booking = Booking.find(params[:id])
  end

  def new
    @activity = Activity.find(params[:activity_id])
    @booking = Booking.new
  end

  def create
    @activity = Activity.find(params[:activity_id])

    @booking = Booking.create(booking_params)

    @booking.user = User.last
    @booking.activity = @activity

    if @booking.save!
      redirect_to root_path
      flash[:alert] = 'Booking made successfully!'
    else
      render 'activities/show', status: :unprocessable_entity
    end
  end

  def destroy
    Booking.destroy(params[:id])
    redirect_to booking_path
  end

  private

  def booking_params
    params.require(:booking).permit(:adult_qty, :child_qty, :status)
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
