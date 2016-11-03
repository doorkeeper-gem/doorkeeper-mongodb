module Doorkeeper
  module Orm
    module AccessGrantMixinErrorHandler
      module ClassMethods
        def by_token(token)
          super
        rescue Mongoid::Errors::DocumentNotFound
          nil
        end
      end

      def self.prepended(base)
        class << base
          prepend ClassMethods
        end
      end
    end
  end
end
