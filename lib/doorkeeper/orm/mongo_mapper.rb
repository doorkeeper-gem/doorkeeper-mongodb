module Doorkeeper
  module Orm
    module MongoMapper
      def self.initialize_models!
        install_dependencies!

        require 'doorkeeper/orm/mongo_mapper/access_grant'
        require 'doorkeeper/orm/mongo_mapper/access_token'
        require 'doorkeeper/orm/mongo_mapper/application'
      end

      def self.initialize_application_owner!
        require 'doorkeeper/models/concerns/ownership'

        Doorkeeper::Application.send :include, Doorkeeper::Models::Ownership
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
    end
  end
end
