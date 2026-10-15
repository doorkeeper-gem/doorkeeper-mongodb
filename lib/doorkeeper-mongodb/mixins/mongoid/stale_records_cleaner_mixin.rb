# frozen_string_literal: true

module DoorkeeperMongodb
  module Mixins
    module Mongoid
      module StaleRecordsCleanerMixin
        def initialize(base_scope)
          @base_scope = base_scope
        end

        # Clears revoked records
        def clean_revoked
          @base_scope.where(:revoked_at.ne => nil, :revoked_at.lt => Time.current).delete_all
        end

        # Clears expired records.
        #
        # A record is expired when its own lifetime is over
        # (`created_at + expires_in < now`), so records with `expires_in: nil`
        # are never removed and records with a lifetime longer than the global
        # `ttl` are kept until they actually expire. The global `ttl`
        # (`access_token_expires_in` / `authorization_code_expires_in`) is only
        # used as a cheap pre-filter on `created_at`; a nil `ttl` means there is
        # no global threshold and the per-record check decides alone.
        #
        # @param ttl [ActiveSupport::Duration, Integer, nil]
        #   global lifetime of the records in seconds
        #
        def clean_expired(ttl)
          now = Time.current
          scope = @base_scope.where(:expires_in.ne => nil)
          scope = scope.where(:created_at.lt => now - ttl) if ttl

          scope.where(
            "$expr" => {
              "$lt" => [
                { "$add" => ["$created_at", { "$multiply" => ["$expires_in", 1000] }] },
                now,
              ],
            },
          ).delete_all
        end
      end
    end
  end
end
