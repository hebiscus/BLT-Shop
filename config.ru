# This file is used by Rack-based servers to start the application.

require_relative "config/environment"
require_relative "FAX-API/app"

map "/" do
  run Rails.application
  Rails.application.load_server
end

map "/fax-api" do
  run FaxApp.new
end
