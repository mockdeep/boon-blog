# This configuration file is for settings which affect your whole site.
#
# For reloadable site metadata like title, author, etc. see
# `src/_data/site_metadata.yml`.
#
# NOTE: this file is *NOT* reloaded automatically when you run
# `bin/bridgetown start`. Restart the server after changing it.

Bridgetown.configure do |config|
  # The base hostname & protocol for the site.
  url "http://blog.boon.gl"

  # Templates are ERB (ported from the old Middleman ERB templates).
  template_engine "erb"

  timezone "America/Los_Angeles"

  # Excerpt/summary support: articles mark the fold with an HTML `<!--more-->`
  # comment. Everything before it is the summary (see
  # plugins/builders/summaries.rb). Because the marker is an HTML comment it
  # renders invisibly, so the full article body needs no special handling.
  config.excerpt_separator = "<!--more-->"

  # Pagination is required for the home page and the per-tag prototype pages.
  pagination do
    enabled true
  end

  # Generates an Atom feed at /feed.xml from src/_data/site_metadata.yml,
  # replacing the old hand-written feed.xml.builder.
  init :"bridgetown-feed"
end
