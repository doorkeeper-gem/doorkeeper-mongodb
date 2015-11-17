module DoorkeeperMongodb
  module Compatible
    extend ActiveSupport::Concern

    module ClassMethods
      def transaction(_ = {}, &block)
        yield
      end
    end

    def transaction(options = {}, &block)
      self.class.transaction(options, &block)
    end

    def lock!(_ = true)
      reload if persisted?
      self
    end
  end
end
