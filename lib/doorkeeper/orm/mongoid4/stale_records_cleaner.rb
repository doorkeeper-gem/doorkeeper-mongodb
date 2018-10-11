# frozen_string_literal: true

module Doorkeeper
  module Orm
    module Mongoid4
      class StaleRecordsCleaner
        include DoorkeeperMongodb::Mixins::Mongoid::StaleRecordsCleanerMixin
      end
    end
  end
end
