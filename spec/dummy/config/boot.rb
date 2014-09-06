require 'rubygems'
require 'bundler/setup'

DOORKEEPER_ORM = (ENV['orm'] || 'mongoid').to_sym unless defined?(DOORKEEPER_ORM)

$LOAD_PATH.unshift File.expand_path('../../../../lib', __FILE__)
