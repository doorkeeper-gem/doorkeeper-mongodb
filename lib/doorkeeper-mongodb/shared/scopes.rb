# frozen_string_literal: true

module DoorkeeperMongodb
  module Shared
    module Scopes
      extend ActiveSupport::Concern

      included do
        field :scopes, type: String
      end

      def scopes=(value)
        scopes = if value.is_a?(Array)
                   Doorkeeper::OAuth::Scopes.from_array(value).to_s
                 else
                   Doorkeeper::OAuth::Scopes.from_string(value.to_s).to_s
                 end

        write_attribute :scopes, scopes
      end

      def scopes_string
        self[:scopes]
      end
    end
  end
end
