# frozen_string_literal: true

module Doorkeeper
  class RedirectUriValidator < ActiveModel::EachValidator
    include DoorkeeperMongodb::Mixins::Mongoid::StaleRecordsCleanerMixin
  end
end
