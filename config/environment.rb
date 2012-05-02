# Load the rails application
require File.expand_path('../application', __FILE__)
require 'sass'

ActionMailer::Base.smtp_settings = {
    :username => "reqeo",
    :password => "reqeo435",
    :domain => "snazzyroom.com",
    :address => "smtp.sendgrid.net",
    :port => 587,
    :authentication => :plain,
    :enable_starttls_auto => true
}

# Initialize the rails application
Snazzy::Application.initialize!




