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
      end
    end
  end
end
