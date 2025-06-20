require "httparty"

class FaxSender
  include HTTParty
  base_uri ENV.fetch("FAX_API_URL", "http://localhost:4567")

  def initialize(file_path, receiver_number:, token:)
    @file_path = file_path
    @receiver_number = receiver_number
    @token = token
  end

  def call
    raise ArgumentError, "File not found: #{@file_path}" unless File.exist?(@file_path)

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

    response = self.class.post("/faxes", options)

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
end
