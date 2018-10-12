# frozen_string_literal: true

module Doorkeeper
  module Orm
    module MongoMapper
      class StaleRecordsCleaner
        def initialize(base_scope)
          @base_scope = base_scope
        end

        def clean_revoked
          @base_scope.where(:revoked_at.ne => nil, :revoked_at.lt => Time.current).delete_all
        end

        def clean_expired(ttl)
          @base_scope.where(:created_at.lt => Time.current - ttl).delete_all
        end
      end
    end
  end
end
