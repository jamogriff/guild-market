class ApiConnectionError < StandardError

  def message
    "Cannot connect to external API."
  end

end
