# frozen_string_literal: true

module DoorkeeperMongodb
  module Mixins
    module Mongoid
      module BaseMixin
        extend ActiveSupport::Concern

        module ClassMethods
          # No-op for Mongoid. Doorkeeper 5.9+ uses with_primary_role to
          # ensure writes go to the primary database when ActiveRecord read
          # replicas are configured. Mongoid doesn't have this concept, so
          # we simply yield.
          def with_primary_role
            yield
          end

          def ordered_by(attribute, direction = :asc)
            order_by(attribute => direction.to_sym)
          end

          def find_by(*args)
            super(*args)
          rescue ::Mongoid::Errors::DocumentNotFound
            nil
          end
        end
      end
    end
  end
end
