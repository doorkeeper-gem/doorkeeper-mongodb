# frozen_string_literal: true

module DoorkeeperMongodb
  module Mixins
    module Mongoid
      module JsonSerializable
        extend ActiveSupport::Concern

        def as_json(*args)
          json = super
          if json.key?("_id")
            json.delete("_id")
            json["id"] = id.to_s
          end
          json
        end
      end
    end
  end
end
