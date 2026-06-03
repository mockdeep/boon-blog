# If you have OpenSSL installed, we recommend updating
# the following line to use 'https'
source 'http://rubygems.org'

ruby '4.0.5'

# activesupport 7.0 references Logger without requiring it; concurrent-ruby
# 1.3.5 dropped the incidental require that used to load it. Must be required
# before middleman (which pulls in activesupport), so keep it first.
gem 'logger'

# activesupport 7.0 requires these stdlib libraries, but Ruby 3.4 moved them
# out of the default gems (into bundled gems), so they must be declared to be
# loadable under Bundler. (benchmark, also required by activesupport, doesn't
# leave the default gems until Ruby 4.0 -- added at that hop.)
gem 'base64'
gem 'bigdecimal'
gem 'drb'
gem 'mutex_m'

gem 'haml', '~> 5.2'
gem 'middleman'
gem 'middleman-blog'
gem 'rouge'
gem 'nokogiri'
gem 'puma'
gem 'rack-contrib' # allows puma to server static files
gem 'redcarpet'
gem 'rake'

gem 'builder' # For feed.xml.builder

gem 'middleman-livereload'
