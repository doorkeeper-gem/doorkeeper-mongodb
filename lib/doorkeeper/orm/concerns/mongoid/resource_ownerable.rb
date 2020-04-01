# frozen_string_literal: true

module Doorkeeper
  module Orm
    module Concerns
      module Mongoid
        module ResourceOwnerable
          extend ActiveSupport::Concern

          module ClassMethods
            # Searches for record by Resource Owner considering Doorkeeper
            # configuration for resource owner association.
            #
            # @param resource_owner [Mongoid::Document, Integer]
            #   resource owner
            #
            # @return [Doorkeeper::AccessGrant, Doorkeeper::AccessToken]
            #   collection of records
            #
            def by_resource_owner(resource_owner)
              if DoorkeeperMongodb.doorkeeper_version?(5, 3) &&
                Doorkeeper.configuration.try(:polymorphic_resource_owner?)
                where(resource_owner: resource_owner)
              else
                where(resource_owner_id: resource_owner_id_for(resource_owner))
              end
            end

            protected

            # Backward compatible way to retrieve resource owner itself (if
            # polymorphic association enabled) or just it's ID.
            #
            # @param resource_owner [Mongoid::Document, Integer]
            #   resource owner
            #
            # @return [ActiveRecord::Base, Integer]
            #   instance of Resource Owner or it's ID
            #
            def resource_owner_id_for(resource_owner)
              if resource_owner.respond_to?(:to_key)
                resource_owner.id
              else
                resource_owner
              end
            end
          end
        end
      end
    end
  end
end
