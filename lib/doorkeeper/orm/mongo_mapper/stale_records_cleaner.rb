# frozen_string_literal: true

module Doorkeeper
  module Orm
    module MongoMapper
      class StaleRecordsCleaner
        include DoorkeeperMongodb::Mixins::MongoMapper::StaleRecordsCleanerMixin
      end
    end
  end
end
