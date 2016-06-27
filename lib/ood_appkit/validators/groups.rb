require 'ood_support'

module OodAppkit
  module Validators
    # Class used to determine if user is in valid list of groups
    class Groups
      # @param groups [Array<String>] list of groups
      def initialize(groups:, **_)
        @groups = [*groups].map {|g| OodSupport::Group.new g}
      end

      # Whether user is in a valid group
      # @return [Boolean] whether in a valid group
      def valid?
        !(@groups & OodSupport::User.new.groups).empty?
      end
    end
  end
end
