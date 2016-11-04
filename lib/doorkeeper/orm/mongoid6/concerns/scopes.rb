module Doorkeeper
  module Models
    module Mongoid5
      module Scopes
        extend ActiveSupport::Concern

        included do
          field :scopes, type: String
        end

        def scopes=(value)
          write_attribute :scopes, value
        end
      end
    end
  end
end
