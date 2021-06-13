class ApplicationController < ActionController::Base
  add_flash_types :info, :warning, :danger

  private

  def error_message(errors)
    errors.full_messages.join(', ')
  end

end
