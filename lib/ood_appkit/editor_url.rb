module OodAppkit
  # A class used to handle URLs for the system file Editor app.
  class EditorUrl
    # The title for this URL
    # @return [String] the title of the URL
    attr_reader :title

    # @param title [String] the title of the URL
    # @param base_url [String] the base URL used to access this app
    # @param edit_url [String] the URL used to request the file editor api
    # @param template [String] the template used to generate URLs for this app
    # @see https://www.rfc-editor.org/rfc/rfc6570.txt RFC describing template format
    def initialize(title: '', base_url: '/', edit_url: '/edit', template: '{/url*}{+path}')
      @title = title
      @template = Addressable::Template.new template

      # Break up into arrays of strings
      @base_url = base_url.split('/').reject(&:empty?)
      @edit_url = edit_url.split('/').reject(&:empty?)
    end

    # URL to access this app
    # @return [Addressable::URI] absolute url to access app
    def url
      @template.expand url: @base_url
    end

    # URL to access this app's file editor API for a given absolute file path
    # @param path [String, #to_s] the absolute path to the file on the filesystem
    # @return [Addressable::URI] absolute url to access path in file editor api
    def edit(path: '')
      @template.expand url: @base_url + @edit_url, path: path.to_s
    end
  end
end
