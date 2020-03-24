require 'doorkeeper-mongodb/version'

require 'active_model'
require 'doorkeeper'
require 'doorkeeper/orm/active_record/redirect_uri_validator'

require 'doorkeeper-mongodb/compatible'
require 'doorkeeper-mongodb/shared/scopes'

require 'doorkeeper/orm/concerns/mongo_mapper/ownership'
require 'doorkeeper/orm/concerns/mongoid/ownership'

require 'doorkeeper-mongodb/mixins/mongo_mapper/base_mixin'
require 'doorkeeper-mongodb/mixins/mongo_mapper/access_grant_mixin'
require 'doorkeeper-mongodb/mixins/mongo_mapper/access_token_mixin'
require 'doorkeeper-mongodb/mixins/mongo_mapper/application_mixin'

require 'doorkeeper/orm/mongo_mapper'

require 'doorkeeper-mongodb/mixins/mongoid/base_mixin'
require 'doorkeeper-mongodb/mixins/mongoid/access_grant_mixin'
require 'doorkeeper-mongodb/mixins/mongoid/access_token_mixin'
require 'doorkeeper-mongodb/mixins/mongoid/application_mixin'
require 'doorkeeper-mongodb/mixins/mongoid/stale_records_cleaner_mixin'

# Maybe we need to squash this into one? With backward compatibility
require 'doorkeeper/orm/mongoid4'
require 'doorkeeper/orm/mongoid5'
require 'doorkeeper/orm/mongoid6'
require 'doorkeeper/orm/mongoid7'

module DoorkeeperMongodb
  def load_locales
    locales_dir = File.expand_path('../../config/locales', __FILE__)
    locales     = Dir[File.join(locales_dir, '*.yml')]

    I18n.load_path |= locales
  end

  module_function :load_locales
end

DoorkeeperMongodb.load_locales
