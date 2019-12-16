# frozen_string_literal: true

module DoorkeeperMongodb
  module Shared
    module Scopes
      extend ActiveSupport::Concern

      def scopes
        OAuth::Scopes.from_string(scopes_string)
      end

      def scopes=(value)
        write_attribute :scopes, Array(value).join(" ")
      end

      def scopes_string
        self[:scopes]
      end

      def includes_scope?(*required_scopes)
        required_scopes.blank? || required_scopes.any? do |scope|
          scopes.exists?(scope.to_s)
        end
      end
    end
  end
end
