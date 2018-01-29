require 'doorkeeper-mongodb/version'

require 'doorkeeper'

require 'doorkeeper-mongodb/compatible'
require 'doorkeeper-mongodb/shared/scopes'
require 'doorkeeper-mongodb/mixins/access_grant_mixin'
require 'doorkeeper-mongodb/mixins/access_token_mixin'
require 'doorkeeper-mongodb/mixins/application_mixin'

require 'doorkeeper/orm/mongoid4'
require 'doorkeeper/orm/mongoid5'
require 'doorkeeper/orm/mongoid6'
require 'doorkeeper/orm/mongo_mapper'

module DoorkeeperMongodb
  def load_locales
    locales_dir = File.expand_path('../../config/locales', __FILE__)
    locales = Dir[File.join(locales_dir, '*.yml')]

    I18n.load_path |= locales
  end

  module_function :load_locales
end

DoorkeeperMongodb.load_locales
