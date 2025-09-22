class FaxSender
  def initialize(file_path, receiver_number:, token:, http_client: default_http_client)
    @file_path = file_path
    @receiver_number = receiver_number
    @token = token
    @http_client = http_client
  end

  def call
    return no_file_found unless File.exist?(@file_path)

    file = File.open(@file_path, "rb")

    options = {
      headers: {
        "Authorization" => "Bearer #{@token}"
      },
      body: {
        receiver_number: @receiver_number,
        file: file
      },
      timeout: 10
    }

    response = @http_client.post("/faxes", options)

    case response.code
    when 201
      Rails.logger.info("[FaxSender] Fax sent successfully: #{response.body}")
      JSON.parse(response.body)
    when 400
      Rails.logger.error("[FaxSender] Bad request: #{response.body}")
      raise "Bad Request: #{response.body}"
    when 403
      Rails.logger.error("[FaxSender] Forbidden: #{response.body}")
      raise "Forbidden: #{response.body}"
    when 500..599
      Rails.logger.error("[FaxSender] Server error (#{response.code}): #{response.body}")
      raise "Server error: #{response.body}"
    else
      Rails.logger.error("[FaxSender] Unexpected response (#{response.code}): #{response.body}")
      raise "Unexpected response: #{response.body}"
    end
  ensure
    file.close if file && !file.closed?
  end

  private

  def default_http_client
    Class.new do
      include HTTParty
      base_uri ENV.fetch("FAX_API_URL", "http://localhost:4567")
    end
  end

  def no_file_found
    Rails.logger.error("File not found: #{@file_path}")
    raise ArgumentError, "File not found: #{@file_path}"
  end
end
