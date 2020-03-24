# frozen_string_literal: true

module DoorkeeperMongodb
  module Mixins
    module Mongoid
      module BaseMixin
        extend ActiveSupport::Concern

        module ClassMethods
          def ordered_by(attribute, direction = :asc)
            order_by(attribute => direction.to_sym)
          end

          def find_by(*args)
            super(*args)
          rescue ::Mongoid::Errors::DocumentNotFound
            nil
          end
        end

        def as_json(*args)
          json_response = super

          json_response["id"] = json_response["_id"]

          json_response
        end
      end
    end
  end
end
