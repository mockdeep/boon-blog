activate :blog do |blog|
  blog.sources = 'articles/{year}-{month}-{day}-{title}.html'
  blog.tag_template = 'tag.html'
  blog.calendar_template = 'calendar.html'
end

activate :disqus do |disqus|
  disqus.shortname = 'boonblog' if ENV['RACK_ENV'] == 'production'
end

activate :asset_hash
activate :syntax, line_numbers: true
set :markdown_engine, :redcarpet
set :markdown, fenced_code_blocks: true,
               smartypants: true,
               space_after_headers: true,
               no_intra_emphasis: true,
               tables: true,
               autolink: true,
               disable_indented_code_blocks: true,
               strikethrough: true,
               lax_spacing: true,
               superscript: true,
               underline: true,
               highlight: true,
               quote: true

page '/feed.xml', layout: false
page '/articles/*', layout: :article_layout

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'
set :build_dir, 'tmp'

configure :build do
end

configure :development do
  activate :livereload
end
