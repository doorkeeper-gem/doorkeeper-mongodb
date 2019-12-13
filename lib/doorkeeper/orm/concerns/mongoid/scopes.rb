# frozen_string_literal: true

module Doorkeeper
  module Models
    module Scopes
      extend ActiveSupport::Concern

      included do
        field :scopes, type: String
      end

      def scopes
        OAuth::Scopes.from_string(scopes_string).to_s
      end

      def scopes=(value)
        write_attribute :scopes, Array(value).join(" ")
      end

      def scopes_string
        self[:scopes]
      end

      def includes_scope?(*required_scopes)
        required_scopes.blank? || required_scopes.any? { |scope| scopes.exists?(scope.to_s) }
      end
    end
  end
end
