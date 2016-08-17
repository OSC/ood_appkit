require 'ood_support'

module OodAppkit
  module Validators
    # Class used to determine if user is in valid list of groups
    class Groups < Validator
      # @param groups [Array<#to_s>] list of groups
      # @param allow [Boolean] whether these groups are allowed access
      def initialize(groups: [], allow: true, **kwargs)
        super(kwargs)
        @groups = groups.map(&:to_s)
        @allow = allow
      end

      # Whether this validation was successful
      # @return [Boolean] whether successful
      def success?
        @allow ? in_user_groups?(@groups) : not_in_user_groups?(@groups)
      end

      private
        # List of groups user is in
        def user_groups
          OodSupport::User.new.groups.map(&:to_s)
        end

        # Whether any groups match user's groups
        def in_user_groups?(groups)
          !(groups & user_groups).empty?
        end

        # Whether groups don't correspond with any user group
        def not_in_user_groups?(groups)
          !in_user_groups?(groups)
        end
    end
  end
end
