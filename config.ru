# This file is used by Rack-based servers to start the application.

require_relative "config/environment"
require_relative "FAX-API/app"

run Rails.application
Rails.application.load_server
run FaxApp.new
