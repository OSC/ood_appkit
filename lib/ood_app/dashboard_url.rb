module OodApp
  # A class used to handle URLs for the system Dashboard app.
  class DashboardUrl
    # @param base_url [String] the base URL used to access this app
    # @param template [String] the template used to generate URLs for this app
    # @see https://www.rfc-editor.org/rfc/rfc6570.txt RFC describing template format
    def initialize(base_url: '/', template: '{/url*}')
      @template = Addressable::Template.new template

      # Break up into arrays of strings
      @base_url = base_url.split('/').reject(&:empty?)
    end

    # URL to access this app
    # @return [Addressable::URI] the url used to access the app
    def url
      @template.expand url: @base_url
    end
  end
end
