require 'nokogiri'

# Various custom filters used by blr.today
#
# All the filters has been gathered in the same module to avoid module name clashing
# Based on https://github.com/endoflife-date/endoflife.date/blob/master/_plugins/end-of-life-filters.rb
# under MIT License.
module BlrTodayFilter

  # Enables Liquid templating in front-matter.
  # See https://fettblog.eu/snippets/jekyll/liquid-in-frontmatter/.
  def liquify(input)
    Liquid::Template.parse(input).render(@context)
  end

  # Parse a URI and return a relevant part
  #
  # Usage:
  # {{ page.url | parse_uri:'host' }}
  # {{ page.url | parse_uri:'scheme' }}
  # {{ page.url | parse_uri:'userinfo' }}
  # {{ page.url | parse_uri:'port' }}
  # {{ page.url | parse_uri:'registry' }}
  # {{ page.url | parse_uri:'path' }}
  # {{ page.url | parse_uri:'opaque' }}
  # {{ page.url | parse_uri:'query' }}
  # {{ page.url | parse_uri:'fragment' }}
  def parse_uri(uri_str, part='host')
    URI::parse(uri_str).send(part.to_s)
  end

  # Extract the elements of the given kind from the HTML.
  def extract_element(html, element)
    entries = []

    @doc = Nokogiri::HTML::DocumentFragment.parse(html)
    @doc.css(element).each do |node|
      entries << node.to_html
    end

    entries
  end

  # Removes the first element of the given kind from the HTML.
  def remove_first_element(html, element)
    doc = Nokogiri::HTML::DocumentFragment.parse(html)
    e = doc.css(element)
    e.first.remove if e&.first
    doc.to_html
  end

end

Liquid::Template.register_filter(BlrTodayFilter)