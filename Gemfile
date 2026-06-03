# If you have OpenSSL installed, we recommend updating
# the following line to use 'https'
source 'http://rubygems.org'

ruby '3.3.11'

# activesupport 7.0 references Logger without requiring it; concurrent-ruby
# 1.3.5 dropped the incidental require that used to load it. Must be required
# before middleman (which pulls in activesupport), so keep it first.
gem 'logger'

gem 'haml', '~> 5.2'
gem 'middleman'
gem 'middleman-blog'
gem 'middleman-syntax'
gem 'nokogiri'
gem 'puma'
gem 'rack-contrib' # allows puma to server static files
gem 'redcarpet'
gem 'rake'

gem 'builder' # For feed.xml.builder

gem 'middleman-livereload'
