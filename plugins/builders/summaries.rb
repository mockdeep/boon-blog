# Gives each post a `summary` — the HTML before the `READMORE` marker — mirroring
# the old Middleman blog `article.summary` behaviour. Listing pages (home, tags)
# render `post.data.summary`.
#
# Bridgetown core's `Resource#summary` only falls back to the first line, so we
# split the raw Markdown on the configured `excerpt_separator` and run it through
# the Markdown converter ourselves.
class Builders::Summaries < SiteBuilder
  def build
    separator = site.config[:excerpt_separator].to_s
    markdown = site.find_converter_instance(Bridgetown::Converters::Markdown)

    generator do
      site.collections.posts.resources.each do |post|
        raw = post.untransformed_content.to_s
        next if separator.empty?

        intro = raw.split(separator, 2).first
        post.data.summary = markdown.convert(intro).html_safe
        # Drop the marker from the full article body so it doesn't render. The
        # marker may sit on its own line or inline mid-sentence, so collapse any
        # surrounding spaces to a single space.
        post.content = raw.gsub(/[ \t]*#{Regexp.escape(separator)}[ \t]*/, " ")
      end
    end
  end
end
