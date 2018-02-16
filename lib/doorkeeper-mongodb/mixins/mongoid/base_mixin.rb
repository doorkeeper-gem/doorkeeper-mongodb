module DoorkeeperMongodb
  module Mixins
    module Mongoid
      module BaseMixin
        extend ActiveSupport::Concern

        module ClassMethods
          def ordered_by(attribute, direction = :asc)
            order_by(attribute => direction.to_sym)
          end
        end
      end
    end
  end
end
