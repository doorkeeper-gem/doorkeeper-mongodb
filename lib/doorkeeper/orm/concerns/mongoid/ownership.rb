# frozen_string_literal: true

module Doorkeeper
  module Orm
    module Concerns
      module Mongoid
        module Ownership
          extend ActiveSupport::Concern

          included do
            belongs_to_options = { polymorphic: true }

            belongs_to_options[:optional] = true if ::Mongoid::VERSION[0].to_i >= 6

            belongs_to :owner, belongs_to_options
            validates :owner, presence: true, if: :validate_owner?
          end

          def validate_owner?
            Doorkeeper.configuration.confirm_application_owner?
          end
        end
      end
    end
  end
end
