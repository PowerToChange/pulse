# $map_hash = {}
# if File.exists?( RAILS_ROOT + '/config/mappings.yml' )
#   $map_hash = File.open( RAILS_ROOT + '/config/mappings.yml' ) { |file| YAML::load(file) }
# end
# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

# Threadsafe breaks model loading from migrations - see 
# https://rails.lighthouseapp.com/projects/8994-ruby-on-rails/tickets/2506-models-are-not-loaded-in-migrations-when-configthreadsafe-is-set
#config.threadsafe! unless (File.basename($0) == "rake" && !ARGV.grep(/db:/).empty?)

ActionMailer::Base.delivery_method = :smtp

ActionMailer::Base.smtp_settings = {
  :address => 'localhost',
  :port => 3535
}
