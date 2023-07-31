# frozen_string_literal: true

require "active_support/lazy_load_hooks"

module Doorkeeper
  module Orm
    module Mongoid8
      def self.run_hooks
        lazy_load do
          require "doorkeeper/orm/mongoid8/access_grant"
          require "doorkeeper/orm/mongoid8/access_token"
          require "doorkeeper/orm/mongoid8/application"
          require "doorkeeper/orm/mongoid8/stale_records_cleaner"
          require "doorkeeper/orm/concerns/mongoid/ownership"
          Doorkeeper::Application.include Doorkeeper::Orm::Concerns::Mongoid::Ownership
        end
        @initialized_hooks = true
      end

      # @deprecated
      def self.initialize_models!
        return if @initialized_hooks

        lazy_load do
          require "doorkeeper/orm/mongoid8/access_grant"
          require "doorkeeper/orm/mongoid8/access_token"
          require "doorkeeper/orm/mongoid8/application"
          require "doorkeeper/orm/mongoid8/stale_records_cleaner"
        end
      end

      # @deprecated
      def self.initialize_application_owner!
        return if @initialized_hooks

        lazy_load do
          require "doorkeeper/orm/concerns/mongoid/ownership"

          Doorkeeper::Application.include Doorkeeper::Orm::Concerns::Mongoid::Ownership
        end
      end

      def self.check_requirements!(_config); end

      def self.lazy_load(&block)
        ActiveSupport.on_load(:mongoid, {}, &block)
      end
    end
  end
end
