# End-to-end smoke test of the Bridgetown dev preview server.
#
# Boots the real `bridgetown start` (verifying the dev serving stack -- puma,
# rack, roda, listen, plus the esbuild frontend watcher -- loads and runs),
# hits it over HTTP, then shuts it down.
#
# We pre-build once so the server has content to serve immediately; `bridgetown
# start` then takes over watching/rebuilding output/.
#
#   bundle exec ruby test/server_test.rb
#
require 'minitest/autorun'
require 'net/http'

# Ensure output/ exists before the server boots.
PREBUILD_OK = system('pnpm run esbuild && bundle exec bridgetown build',
                     out: File::NULL, err: File::NULL)

class ServerTest < Minitest::Test
  PORT = 4568
  LOG  = '/tmp/bt_test_server.log'

  def setup
    assert PREBUILD_OK, 'prebuild failed; cannot test the dev server'

    # Own process group so we can reliably kill the server and its children
    # (the esbuild watcher in particular).
    @pid = Process.spawn(
      'bundle', 'exec', 'bridgetown', 'start', '--port', PORT.to_s,
      out: LOG, err: LOG, pgroup: true
    )
    wait_for_server
  end

  def teardown
    return unless @pid
    Process.kill('TERM', -@pid) # negative pid => whole process group
    Process.wait(@pid)
  rescue Errno::ESRCH, Errno::ECHILD
    # already gone
  end

  def test_serves_homepage
    res = get('/')
    assert_equal '200', res.code, "expected 200, got #{res.code}"
    assert_includes res.body, '<title>Boon Blog'
    assert_includes res.body, 'Recent Articles'
  end

  private

  def get(path)
    Net::HTTP.get_response(URI("http://localhost:#{PORT}#{path}"))
  end

  def wait_for_server
    45.times do
      begin
        res = get('/')
        return res if res.code == '200'
      rescue Errno::ECONNREFUSED, EOFError, Net::ReadTimeout
        # not up yet
      end
      sleep 1
    end
    log = File.exist?(LOG) ? File.read(LOG) : '(no log)'
    flunk "bridgetown start did not serve on port #{PORT}:\n#{log}"
  end
end
