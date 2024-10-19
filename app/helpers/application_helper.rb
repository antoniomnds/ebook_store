module ApplicationHelper
  def error_messages_for(object)
    render "application/error_messages", object: object
  end
end
