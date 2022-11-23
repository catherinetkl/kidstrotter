class BookingsController < ApplicationController
  # before_action :authenticate, only: %i[new create]

  def index
    @bookings = Booking.all
  end

  def show
    @activity = Activity.find(params[:id])
    @booking = Booking.new
  end

  def new
    @activity = Activity.find(params[:product_id])
    @booking = Booking.new
  end

  def create
    @activity = Activity.find(params[:product_id])

    @booking = Booking.new
    @booking.user = current_user
    @booking.activity = @activity
    # @booking.status = :pending

    if @booking.save
      redirect_to root_path
      flash[:alert] = "Booking made succesfully. Please wait for the seller's reply."
    else
      render 'activity/show', status: :unprocessable_entity
    end
  end

  private

  def booking_params
    params.require(:booking).permit(:adult_qty, :child_qty, :adult_price, :child_price, :activity_id)
  end

  # def authenticate
  #   if current_user
  #     ''
  #   else
  #     redirect_to new_user_session_path
  #     flash[:alert] = 'You must be signed in to do this.'
  #   end
  # end
end
