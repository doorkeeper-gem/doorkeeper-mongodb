DatabaseCleaner[:mongo_mapper].strategy = :truncation
DatabaseCleaner[:mongo_mapper].clean_with :truncation

RSpec.configure do |config|
  config.before :suite do
    Doorkeeper::Application.create_indexes
    Doorkeeper::AccessGrant.create_indexes
    Doorkeeper::AccessToken.create_indexes
  end

  # This is a hack to fix a bug in a spec test in Doorkeeper.
  # I submitted a PR to fix this properly here: https://github.com/doorkeeper-gem/doorkeeper/pull/1153/files
  #
  # Once the spec is fixed, this should be removable.
  # If it is not removed, it shouldn't cause any problems, it will only prevent this same issue from happening
  # again if another bad spec is created.
  config.before :each do
    allow(Doorkeeper).to receive(:configure).and_wrap_original do |orig_configure, &block|
      config = orig_configure.call do
        orm DOORKEEPER_ORM

        instance_eval(&block)
      end
    end
  end
end
