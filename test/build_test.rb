# End-to-end test of the static build output.
#
# Runs the real deploy build -- the esbuild frontend bundle followed by
# `bridgetown build` (verifying the render/asset gem + node toolchain is
# compatible and loads), then asserts the generated artifact looks right.
#
#   bundle exec ruby test/build_test.rb
#
require 'minitest/autorun'

# Bridgetown's default destination.
BUILD_DIR = File.expand_path('../../output', __FILE__)

# Build once at load time rather than per-test. esbuild must run first so the
# frontend manifest exists for the `asset_path` helper; then the static site.
BUILD_OUTPUT = `pnpm run esbuild 2>&1 && bundle exec bridgetown build 2>&1`
BUILD_STATUS = $?.exitstatus

class BuildTest < Minitest::Test
  def test_build_exits_successfully
    assert_equal 0, BUILD_STATUS, "build failed:\n#{BUILD_OUTPUT}"
  end

  def test_index_has_expected_content
    index = File.join(BUILD_DIR, 'index.html')
    assert File.exist?(index), "expected #{index} to be generated"

    html = File.read(index)
    # Markers from the shared layout (default.erb + nav/footer partials),
    # so they hold on the homepage and every article page.
    assert_includes html, '<title>Boon Blog'
    assert_includes html, 'Recent Articles'
    assert_includes html, 'class="blog-title"'
    assert_includes html, 'blog.boon.gl/feed.xml'
  end

  def test_assets_compiled
    # esbuild fingerprints the bundle name: _bridgetown/static/index.<hash>.css,
    # so match by glob.
    css = Dir[File.join(BUILD_DIR, '_bridgetown', 'static', 'index.*.css')]
    refute_empty css, 'expected a fingerprinted esbuild CSS bundle'
  end

  def test_layout_chrome_present
    html = File.read(File.join(BUILD_DIR, 'index.html'))
    assert_includes html, 'class="rss"', 'expected the nav RSS link'
    assert_includes html, 'Recent Articles', 'expected the footer Recent Articles heading'
    assert_includes html, 'Tags', 'expected the footer Tags heading'
  end

  def test_blog_features_generated
    # Pagination/tag/feed parity with the old Middleman blog.
    assert File.exist?(File.join(BUILD_DIR, 'feed.xml')), 'expected the Atom feed'
    assert File.exist?(File.join(BUILD_DIR, 'tags', 'react', 'index.html')),
           'expected a generated per-tag page'
    post = File.join(BUILD_DIR, '2017', '11', '28', 'react-elm-wrapper', 'index.html')
    assert File.exist?(post), 'expected an article page'
  end
end
