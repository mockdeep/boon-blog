source 'https://rubygems.org'

ruby '4.0.5'

# Static site generator (replaces Middleman).
gem 'bridgetown', '~> 2.2.0'
gem 'bridgetown-feed' # generates the Atom feed.xml

# Production serving: puma boots config.ru, which serves the built static
# site (output/) via Rack::TryStatic. This is the path Heroku uses.
gem 'puma'
gem 'rack-contrib' # provides Rack::TryStatic

gem 'rake'

group :test do
  gem 'minitest'
end
