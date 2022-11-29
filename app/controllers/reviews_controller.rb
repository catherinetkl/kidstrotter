class ReviewsController < ApplicationController
  before_action :authenticate

  def index
    # @reviews = Review.where(user: current_user)
    @reviews = current_user.reviews.all
  end

  def new
    @booking = Booking.find(params[:booking_id])
    @review = Review.new
  end

  def create
    @booking = Booking.find(params[:booking_id])

    @review = Review.new(review_params)
    @review.user = current_user
    @review.booking = @booking

    if @review.save
      redirect_to reviews_path
      flash[:alert] = 'Review made successfully!'
    else
      flash[:alert] = 'Review failed ..'
      redirect_to reviews_path
    end
  end

  def destroy
    Review.destroy(params[:id])
    redirect_to reviews_path
  end

  private

  def review_params
    params.require(:review).permit(:comment, :rating)
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
