module DoorkeeperMongodb
  module Mixins
    module MongoMapper
      module BaseMixin
        extend ActiveSupport::Concern

        module ClassMethods
          def ordered_by(attribute, direction = :asc)
            sort(attribute.to_sym.send(direction.to_sym))
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
