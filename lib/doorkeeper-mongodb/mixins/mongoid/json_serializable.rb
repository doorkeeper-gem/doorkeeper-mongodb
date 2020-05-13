# frozen_string_literal: true

module DoorkeeperMongodb
  module Mixins
    module Mongoid
      module JsonSerializable
        extend ActiveSupport::Concern

        def as_json(*args)
          json = super
          json["id"] = json.delete("_id") if json.key?("_id")
          json
        end
      end
    end
  end
end
