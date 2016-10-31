module Doorkeeper
  module Orm
    module AccessTokenMixinErrorHandler
      module ClassMethods
        def by_token(token)
          super
        rescue Mongoid::Errors::DocumentNotFound
          nil
        end

        def by_refresh_token(refresh_token)
          super
        rescue Mongoid::Errors::DocumentNotFound
          nil
        end

        def last_authorized_token_for(application_id, resource_owner_id)
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
