# This file is used by Rack-based servers to start the application.
require ::File.expand_path('../config/environment',  __FILE__)
map ActionController::Base.config.try(:relative_url_root) || "/" do
  run Discourse::Application
end

require "gctools/oobgc"
GC::OOB.setup
PhusionPassenger.require_passenger_lib 'rack/out_of_band_gc'
use PhusionPassenger::Rack::OutOfBandGc, :strategy => :gctools_oobgc
