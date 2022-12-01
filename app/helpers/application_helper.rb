module ApplicationHelper
  def is_organizer?
    current_user && current_user.organizer
  end

  def has_bookings?
    @bookings = Booking.joins(:activity).where(activity: { organizer: current_user.organizer })
    current_user && @bookings == true
  end
end
