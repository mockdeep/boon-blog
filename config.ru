# Production serving stack (Heroku): puma boots this file and serves the static
# site that Bridgetown builds into `output/`, via Rack::TryStatic. The dev
# preview server is separate -- use `bin/bridgetown start`.

require 'rack/deflater'
require 'rack/static'
require 'rack/contrib/try_static'

use Rack::Deflater
use Rack::TryStatic,
  root: 'output',
  urls: %w[/],
  try: %w[.html index.html /index.html]

FIVE_MINUTES = 300

run lambda { |_env|
  [
    404,
    {
      'Content-Type'  => 'text/html',
      'Cache-Control' => "public, max-age=#{FIVE_MINUTES}"
    },
    ['File not found']
  ]
}
