# frozen_string_literal: true

# [NOTE] MongoMapper support was dropped, so now only Mongoid
class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :password, type: String

  attr_accessible :name, :password if defined?(::ProtectedAttributes)

  def self.authenticate!(name, password)
    User.where(name: name, password: password).first
  end
end
