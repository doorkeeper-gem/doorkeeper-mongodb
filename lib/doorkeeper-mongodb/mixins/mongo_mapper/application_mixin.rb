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
          validates :confidential, inclusion: { in: [true, false] }

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
            app = by_uid(uid)
            return unless app
            return app if secret.blank? && !app.confidential
            return unless app.secret == secret
            app
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

          def supports_confidentiality?
            if ENV['RAILS_ENV'] ||= 'test'
              if respond_to?(:column_names)
                column_names.include?("confidential")
              else
                fields.include?("confidential")
              end
            else
              fields.include?("confidential")
            end
          end
        end

        # Fallback to existing, default behaviour of assuming all apps to be
        # confidential if the migration hasn't been run
        def confidential
          return super if self.class.supports_confidentiality?

          ActiveSupport::Deprecation.warn 'You are susceptible to security bug ' \
            'CVE-2018-1000211. Please follow instructions outlined in ' \
            'Doorkeeper::CVE_2018_1000211_WARNING'

          true
        end

        alias_method :confidential?, :confidential

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
