module Doorkeeper
  module Orm
    module ApplicationMixinErrorHandler
      module ClassMethods
        def by_uid_and_secret(uid, secret)
          super
        rescue Mongoid::Errors::DocumentNotFound
          nil
        end

        def by_uid(uid)
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
