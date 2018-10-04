require 'active_support/lazy_load_hooks'

module Doorkeeper
  module Orm
    module MongoMapper
      def self.initialize_models!
        install_dependencies!

        lazy_load do
          require 'doorkeeper/orm/mongo_mapper/access_grant'
          require 'doorkeeper/orm/mongo_mapper/access_token'
          require 'doorkeeper/orm/mongo_mapper/application'
          require 'doorkeeper/orm/mongo_mapper/stale_records_cleaner'
        end
      end

      def self.initialize_application_owner!
        lazy_load do
          require 'doorkeeper/models/concerns/ownership'

          Doorkeeper::Application.send :include, Doorkeeper::Models::Ownership
        end
      end

      def self.check_requirements!(_config); end

      def self.install_dependencies!
        if ::ActiveModel::VERSION::MAJOR >= 5
          begin
            require 'activemodel-serializers-xml'
          rescue LoadError
            $stderr.print 'Failed to load ActiveModel::Serializers::Xml. ' \
                          "You need to add 'activemodel-serializers-xml' gem to your Gemfile."
            raise
          end
        end
      end

      def self.lazy_load(&block)
        ActiveSupport.on_load(:mongo_mapper, {}, &block)
      end
    end
  end
end
