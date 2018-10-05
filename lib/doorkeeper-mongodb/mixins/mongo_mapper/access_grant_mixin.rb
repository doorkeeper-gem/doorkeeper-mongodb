module DoorkeeperMongodb
  module Mixins
    module MongoMapper
      module AccessGrantMixin
        extend ActiveSupport::Concern

        include Doorkeeper::OAuth::Helpers
        include Doorkeeper::Models::Expirable
        include Doorkeeper::Models::Revocable
        include Doorkeeper::Models::Accessible
        include Doorkeeper::Models::Scopes
        include BaseMixin

        included do
          belongs_to :application, class_name: 'Doorkeeper::Application'

          validates :resource_owner_id, :application_id, :token, :expires_in, :redirect_uri, presence: true
          validates :token, uniqueness: true

          before_validation :generate_token, on: :create
        end

        # never uses pkce, if pkce migrations were not generated
        def uses_pkce?
          pkce_supported? && code_challenge.present?
        end

        def pkce_supported?
          respond_to? :code_challenge
        end

        module ClassMethods
          # Searches for Doorkeeper::AccessGrant record with the
          # specific token value.
          #
          # @param token [#to_s] token value (any object that responds to `#to_s`)
          #
          # @return [Doorkeeper::AccessGrant, nil] AccessGrant object or nil
          #   if there is no record with such token
          #
          def by_token(token)
            where(token: token.to_s).first
          end
        end

        private

        # Generates token value with UniqueToken class.
        #
        # @return [String] token value
        #
        def generate_token
          self.token = UniqueToken.generate
        end
      end
    end
  end
end
