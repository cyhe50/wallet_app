class API::V1::Formatter::Error
  def self.call(message)
    {
      status: "error",
      error_code: error_code,
      response: error_message
    }.to_json
  end
end
