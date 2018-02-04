require 'active_support/lazy_load_hooks'

module Doorkeeper
  module Orm
    module Mongoid4
      def self.initialize_models!
        lazy_load do
          require 'doorkeeper/orm/mongoid4/access_grant'
          require 'doorkeeper/orm/mongoid4/access_token'
          require 'doorkeeper/orm/mongoid4/application'
        end
      end

      def self.initialize_application_owner!
        lazy_load do
          require 'doorkeeper/models/concerns/ownership'

          Doorkeeper::Application.send :include, Doorkeeper::Models::Ownership
        end
      end

      def self.check_requirements!(_config); end

      def self.lazy_load(&block)
        ActiveSupport.on_load(:mongoid, {}, &block)
      end
    end
  end
end
