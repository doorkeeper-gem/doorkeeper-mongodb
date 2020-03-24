# frozen_string_literal: true

# [NOTE] MongoMapper support was dropped
class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :password, type: String

  if ::Rails.version.to_i < 4 || defined?(::ProtectedAttributes)
    attr_accessible :name, :password
  end

  def self.authenticate!(name, password)
    User.where(name: name, password: password).first
  end
end
