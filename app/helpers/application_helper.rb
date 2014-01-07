module ApplicationHelper

  def ui_display? params, controller, action
    if params[:controller] == controller && params[:action] == action
      return true
    else
      return false
    end
  end

  def is_root? request
    if request.path == "/"
      return true
    else
      return false
    end
  end

end