Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  if Rails.application.config.respond_to? :facebook
    provider :facebook, Rails.application.config.facebook[:app_id], Rails.application.config.facebook[:app_secret],
             scope: "email user_birthday user_interests user_likes user_location read_stream publish_stream"
  end

  if Rails.application.config.respond_to? :pinterest
    provider :pinterest, Rails.application.config.facebook[:pinterest], Rails.application.config.facebook[:pinterest]
  end

  #OmniAuth::Configuration.instance.on_failure = Proc.new do
  #  Rack::Response.new(["302 Moved"], 302, 'Location' => "/session/failure").finish
  #end

  OmniAuth::Configuration.instance.on_failure = SnazzyFailureEndpoint

end

class SnazzyFailureEndpoint < OmniAuth::FailureEndpoint
  def call
    Rack::Response.new(["302 Moved"], 302, 'Location' => "/session/failure?#{env['QUERY_STRING']}").finish
  end
end


