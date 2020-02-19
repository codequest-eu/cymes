require "fae/engine"
require 'carrierwave'
require "zeitwerk"

loader = Zeitwerk::Loader.for_gem
loader.setup

module Fae
  extend Fae::Options
end
