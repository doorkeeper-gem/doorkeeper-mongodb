# frozen_string_literal: true

require 'active_support/lazy_load_hooks'

module Doorkeeper
  module Orm
    module Mongoid7
      def self.initialize_models!
        lazy_load do
          require 'doorkeeper/orm/mongoid7/access_grant'
          require 'doorkeeper/orm/mongoid7/access_token'
          require 'doorkeeper/orm/mongoid7/application'
          require 'doorkeeper/orm/mongoid7/stale_records_cleaner'
        end
      end

      def self.initialize_application_owner!
        lazy_load do
          require 'doorkeeper/orm/concerns/mongoid/accessible'
          require 'doorkeeper/orm/concerns/mongoid/expirable'
          require 'doorkeeper/orm/concerns/mongoid/orderable'
          require 'doorkeeper/orm/concerns/mongoid/ownership'
          require 'doorkeeper/orm/concerns/mongoid/reusable'
          require 'doorkeeper/orm/concerns/mongoid/revocable'
          require 'doorkeeper/orm/concerns/mongoid/scopes'
          require 'doorkeeper/orm/concerns/mongoid/secret_storable'

          Doorkeeper::Application.include Doorkeeper::Orm::Concerns::Mongoid::Accessible
          Doorkeeper::Application.include Doorkeeper::Orm::Concerns::Mongoid::Expirable
          Doorkeeper::Application.include Doorkeeper::Orm::Concerns::Mongoid::Orderable
          Doorkeeper::Application.include Doorkeeper::Orm::Concerns::Mongoid::Ownership
          Doorkeeper::Application.include Doorkeeper::Orm::Concerns::Mongoid::Reusable
          Doorkeeper::Application.include Doorkeeper::Orm::Concerns::Mongoid::Revocable
          Doorkeeper::Application.include Doorkeeper::Orm::Concerns::Mongoid::Scopes
          Doorkeeper::Application.include Doorkeeper::Orm::Concerns::Mongoid::SecretStorable
        end
      end

      def self.check_requirements!(_config); end

      def self.lazy_load(&block)
        ActiveSupport.on_load(:mongoid, {}, &block)
      end
    end
  end
end
