# Gives each post a `summary` — the HTML before the `<!--more-->` marker —
# mirroring the old Middleman blog `article.summary` behaviour. Listing pages
# (home, tags) render `post.data.summary`.
#
# Bridgetown core's `Resource#summary` only falls back to the first line, so we
# split the raw Markdown on the configured `excerpt_separator` and run it through
# the Markdown converter ourselves. The marker is an HTML comment, so it stays
# invisible in the full article body and needs no stripping.
class Builders::Summaries < SiteBuilder
  def build
    separator = site.config[:excerpt_separator].to_s
    markdown = site.find_converter_instance(Bridgetown::Converters::Markdown)

    generator do
      site.collections.posts.resources.each do |post|
        next if separator.empty?

        intro = post.untransformed_content.to_s.split(separator, 2).first
        post.data.summary = markdown.convert(intro).html_safe
      end
    end
  end
end
