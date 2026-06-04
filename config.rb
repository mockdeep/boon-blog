require 'rouge'
require 'rouge/plugins/redcarpet'
require 'middleman-core/renderers/redcarpet'

# Subclasses Middleman's renderer so the image/link helpers keep working, and
# mixes in SmartyPants . The Github theme CSS (syntax_highlighting.css.erb) is
# scoped to `.highlight`, which is the wrapper we emit below.
class RougeRedcarpetHTML < Middleman::Renderers::MiddlemanRedcarpetHTML
  include Redcarpet::Render::SmartyPants
  include Rouge::Plugins::Redcarpet

  def block_code(code, language)
    lexer = Rouge::Lexer.find_fancy(language, code) || Rouge::Lexers::PlainText
    table = Rouge::Formatters::HTMLTable.new(Rouge::Formatters::HTML.new)
    %(<div class="highlight">#{table.format(lexer.lex(code))}</div>)
  end
end

activate :blog do |blog|
  blog.paginate = true
  blog.sources = 'articles/{year}-{month}-{day}-{title}.html'
  blog.tag_template = 'tag.html'
  blog.calendar_template = 'calendar.html'
end

activate :asset_hash
set :markdown_engine, :redcarpet
set :markdown, renderer: RougeRedcarpetHTML,
               fenced_code_blocks: true,
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
