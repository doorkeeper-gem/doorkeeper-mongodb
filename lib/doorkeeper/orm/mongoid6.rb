module Doorkeeper
  module Orm
    module Mongoid6
      def self.initialize_models!
        require 'doorkeeper/orm/mongoid6/access_grant'
        require 'doorkeeper/orm/mongoid6/access_token'
        require 'doorkeeper/orm/mongoid6/application'
      end

      def self.initialize_application_owner!
        require 'doorkeeper/orm/mongoid6/concerns/ownership'

        Doorkeeper::Application.send :include, Doorkeeper::Models::Mongoid6::Ownership
      end

      def self.check_requirements!(_config); end
    end
  end
end
