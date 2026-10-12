require 'kramdown'
require 'kramdown-parser-gfm'

module OodAppkit
  # A markdown formatter that matches the syntax of a Redcarpet::Markdown
  class MarkdownParser
    def render(content)
      Kramdown::Document.new(content, input: 'GFM').to_html
    end
  end
end

