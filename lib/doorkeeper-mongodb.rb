# frozen_string_literal: true

require "doorkeeper-mongodb/version"

require "active_model"
require "doorkeeper"
begin
  require "doorkeeper/orm/active_record/redirect_uri_validator"
rescue LoadError
  # for old Doorkeeper version before this change
end

require "doorkeeper-mongodb/compatible"
require "doorkeeper-mongodb/shared/scopes"

require "doorkeeper/orm/concerns/mongoid/ownership"
require "doorkeeper/orm/concerns/mongoid/resource_ownerable"

require "doorkeeper-mongodb/mixins/mongoid/base_mixin"
require "doorkeeper-mongodb/mixins/mongoid/access_grant_mixin"
require "doorkeeper-mongodb/mixins/mongoid/access_token_mixin"
require "doorkeeper-mongodb/mixins/mongoid/application_mixin"
require "doorkeeper-mongodb/mixins/mongoid/stale_records_cleaner_mixin"

# Maybe we need to squash this into one? With backward compatibility
require "doorkeeper/orm/mongoid4"
require "doorkeeper/orm/mongoid5"
require "doorkeeper/orm/mongoid6"
require "doorkeeper/orm/mongoid7"

module DoorkeeperMongodb
  def load_locales
    locales_dir = File.expand_path("../../config/locales", __FILE__)
    locales     = Dir[File.join(locales_dir, "*.yml")]

    I18n.load_path |= locales
  end

  module_function :load_locales

  def doorkeeper_version?(major, minor)
    Doorkeeper::VERSION::MAJOR >= major &&
      Doorkeeper::VERSION::MINOR >= minor
  end

  module_function :doorkeeper_version?
end

DoorkeeperMongodb.load_locales
