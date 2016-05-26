module OodApp
  # A class used to handle URLs for the system Files app.
  class FilesUrl
    # @param title [String] the title of the URL
    # @param base_url [String] the base URL used to access this app
    # @param fs_url [String] the URL used to request a filesystem view in the app
    # @param api_url [String] the URL used to request the app's api
    # @param template [String] the template used to generate URLs for this app
    # @see https://www.rfc-editor.org/rfc/rfc6570.txt RFC describing template format
    def initialize(title: '', base_url: '/', fs_url: '/fs', api_url: '/api/v1/fs', template: '{/url*}{+path}')
      @title = title
      @template = Addressable::Template.new template

      # Break up into arrays of strings
      @base_url = base_url.split('/').reject(&:empty?)
      @fs_url   = fs_url.split('/').reject(&:empty?)
      @api_url  = api_url.split('/').reject(&:empty?)
    end

    # URL to access this app for a given absolute file path
    # @param path [String, #to_s] the absolute path to the file on the filesystem
    # @return [Addressable::URI] absolute url to access path in files app
    def url(path: '')
      @template.expand url: @base_url + @fs_url, path: path.to_s
    end

    # URL to access this app's API for a given absolute file path
    # @param path [String, #to_s] the absolute path to the file on the filesystem
    # @return [Addressable::URI] absolute url to access path in files app api
    def api(path: '')
      @template.expand url: @base_url + @api_url, path: path.to_s
    end
  end
end
