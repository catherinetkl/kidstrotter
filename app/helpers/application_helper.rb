module ApplicationHelper
  def is_organizer?
    current_user && current_user.organizer
  end
end
