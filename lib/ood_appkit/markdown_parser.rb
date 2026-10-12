require 'kramdown'

module OodAppkit
  # A markdown formatter that matches the syntax of a Redcarpet::Markdown
  class MarkdownParser
    def render(content)
      Kramdown::Document.new(content).to_html
    end
  end
end

