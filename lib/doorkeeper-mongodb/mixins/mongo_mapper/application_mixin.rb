module DoorkeeperMongodb
  module Mixins
    module MongoMapper
      module ApplicationMixin
        extend ActiveSupport::Concern

        include Doorkeeper::OAuth::Helpers
        include Doorkeeper::Models::Scopes
        include BaseMixin

        included do
          many :access_grants, dependent: :destroy, class_name: 'Doorkeeper::AccessGrant'
          many :access_tokens, dependent: :destroy, class_name: 'Doorkeeper::AccessToken'

          validates :name, :secret, :uid, presence: true
          validates :uid, uniqueness: true
          validates :redirect_uri, redirect_uri: true

          before_validation :generate_uid, :generate_secret, on: :create

          def redirect_uri=(uris)
            super(uris.is_a?(Array) ? uris.join("\n") : uris)
          end
        end

        module ClassMethods
          # Returns an instance of the Doorkeeper::Application with
          # specific UID and secret.
          #
          # @param uid [#to_s] UID (any object that responds to `#to_s`)
          # @param secret [#to_s] secret (any object that responds to `#to_s`)
          #
          # @return [Doorkeeper::Application, nil] Application instance or nil
          #   if there is no record with such credentials
          #
          def by_uid_and_secret(uid, secret)
            where(uid: uid.to_s, secret: secret.to_s).first
          end

          # Returns an instance of the Doorkeeper::Application with specific UID.
          #
          # @param uid [#to_s] UID (any object that responds to `#to_s`)
          #
          # @return [Doorkeeper::Application, nil] Application instance or nil
          #   if there is no record with such UID
          #
          def by_uid(uid)
            where(uid: uid.to_s).first
          end
        end

        private

        def has_scopes?
          Doorkeeper::Application.keys.keys.include?("scopes")
        end

        def generate_uid
          if uid.blank?
            self.uid = UniqueToken.generate
          end
        end

        def generate_secret
          if secret.blank?
            self.secret = UniqueToken.generate
          end
        end
      end
    end
  end
end
