# End-to-end test of the static build output.
#
# Runs the real `middleman build` once (verifying the render/asset gem stack
# is compatible and loads), then asserts the generated artifact looks right.
#
#   bundle exec ruby test/build_test.rb
#
require 'minitest/autorun'

# Mirrors `set :build_dir, 'tmp'` in config.rb.
BUILD_DIR = File.expand_path('../../tmp', __FILE__)

# Build once at load time rather than per-test, so we run middleman once.
BUILD_OUTPUT = `bundle exec middleman build 2>&1`
BUILD_STATUS = $?.exitstatus

class BuildTest < Minitest::Test
  def test_build_exits_successfully
    assert_equal 0, BUILD_STATUS, "middleman build failed:\n#{BUILD_OUTPUT}"
  end

  def test_index_has_expected_content
    index = File.join(BUILD_DIR, 'index.html')
    assert File.exist?(index), "expected #{index} to be generated"

    html = File.read(index)
    # Markers from the shared layout (layout.html.erb + nav/footer partials),
    # so they hold on the homepage and every article page.
    assert_includes html, '<title>Boon Blog'
    assert_includes html, 'Recent Articles'
    assert_includes html, 'class="blog-title"'
    assert_includes html, 'blog.boon.gl/feed.xml'
  end

  def test_assets_compiled
    # asset_hash fingerprints the filename (all-<hash>.css), so match by glob.
    css = Dir[File.join(BUILD_DIR, 'stylesheets', 'all-*.css')]
    refute_empty css, 'expected a fingerprinted stylesheets/all-*.css'
  end

  def test_layout_chrome_present
    html = File.read(File.join(BUILD_DIR, 'index.html'))
    assert_includes html, 'class="rss"', 'expected the nav RSS link'
    assert_includes html, 'Recent Articles', 'expected the footer Recent Articles heading'
    assert_includes html, 'Tags', 'expected the footer Tags heading'
  end
end
