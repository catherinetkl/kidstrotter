class BookingsController < ApplicationController
  before_action :authenticate

  def index
    @bookings = current_user.bookings.all

    # start_date = params.fetch(:start_date, Date.today).to_date
    # @bookings = Booking.where(
    #   start_time: start_date.beginning_of_month.beginning_of_week..start_date.end_of_month.end_of_week
    # )
  end

  def organizer_index
    @users = User.all
    @bookings = Booking.all
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

  def edit
    @booking = Booking.find(params[:id])
  end

  def update
    @booking = Booking.find(params[:id])
    @booking.update_attributes(bookings_params)
    if @booking.save
      redirect_to @booking, notice: 'Successfully changed status'
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
    # :start_time, :end_time
    params.require(:booking).permit(:adult_qty, :child_qty, :start_time, :status)
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
