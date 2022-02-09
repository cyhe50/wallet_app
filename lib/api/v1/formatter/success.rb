class API::V1::Formatter::Success
  def self.call(object, env)
    {
      status: "success",
      data: object
    }.to_json
  end
end
