module OodApp
  # A class used to handle URLs for the system Shell app.
  class ShellApp
    # @param base_url [String] the base URL used to access this app
    # @param template [String] the template used to generate URLs for this app
    # @see https://www.rfc-editor.org/rfc/rfc6570.txt RFC describing template format
    def initialize(base_url: '/', ssh_url: '/ssh', template: '{/url*}/{host}{+path}')
      @template = Addressable::Template.new template

      # Break up into arrays of strings
      @base_url = base_url.split('/').reject(&:empty?)
      @ssh_url  = ssh_url.split('/').reject(&:empty?)
    end

    # URL to access this app for a given host and absolute file path
    # @param host [String] the host the app will make an ssh connection with
    # @param path [String, #to_s] the absolute path to the directory ssh app opens up in
    # @return [Addressable::URI] the url used to access the app
    def url(path: '', host: 'default')
      @template.expand url: @base_url + @ssh_url, path: path.to_s, host: host
    end
  end
end
