# frozen_string_literal: true

module HtmlHelpers
  def to_html(val)
    case val
    when Array
      to_ul(val)
    when Hash
      to_dl(val)
    else
      val
    end
  end

  def to_dl(hash)
    out = "<dl>\n"
    hash.each do |key, val|
      out += "<dt>#{key}</dt>\n"
      dd = to_html(val)
      out += "<dd>#{dd}</dd>\n"
    end
    out += "</dl>\n"

    out
  end

  def to_ul(array)
    out = "<ul>\n"
    array.each do |item|
      li = to_html(item)
      out += "<li>#{li}</li>\n"
    end
    out += "</ul>\n"

    out
  end

  def to_anchor(str)
    str.downcase.gsub(/[^a-z0-9]+/, "-").sub(/^-|-$/, "")
  end

  def url(url_str)
    url_str.sub(%r{^https?://(www\.)?}, "")
  end
end
