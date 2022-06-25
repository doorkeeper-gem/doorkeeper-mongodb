# frozen_string_literal: true

require_relative "mongoid"

Mongoid.logger.level = Logger::ERROR
Mongo::Logger.logger.level = Logger::ERROR
