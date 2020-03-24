# frozen_string_literal: true

require_relative "mongoid.rb"

Mongoid.logger.level = Logger::ERROR
Mongo::Logger.logger.level = Logger::ERROR
