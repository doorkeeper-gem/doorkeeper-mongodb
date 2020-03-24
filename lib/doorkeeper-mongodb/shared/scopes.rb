# frozen_string_literal: true

module DoorkeeperMongodb
  module Shared
    module Scopes
      extend ActiveSupport::Concern

      included do
        field :scopes, type: String
      end

      def scopes=(value)
        write_attribute :scopes, value
      end
    end
  end
end
