module EventsHelper
  def active_event? event, current_user
    if user_signed_in? && current_user.id == event.organizer_id && event.start > Time.now
      return true
    else
      return false
    end
  end
end
