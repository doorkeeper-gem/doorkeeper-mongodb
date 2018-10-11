module DoorkeeperMongodb
  module Mixins
    module MongoMapper
      module BaseMixin
        extend ActiveSupport::Concern

        included do
          def update(*args)
            return self if args.all?(&:blank?)

            set(*args)
          end
        end

        module ClassMethods
          def ordered_by(attribute, direction = :asc)
            sort(attribute.to_sym.send(direction.to_sym))
          end
        end

        def as_json(*args)
          json_response = super
          json_response['id'] = id.to_s

          json_response
        end
      end
    end
  end
end
