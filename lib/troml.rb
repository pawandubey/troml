# frozen_string_literal: true

require_relative "troml/version"
require "rutie"
require "date"

module Troml
  Rutie.new(:troml).init "Init_troml", __dir__

  class Error < StandardError; end

  class ExtParseError < Error; end

  def self.parse(raw_toml)
    TromlExt.parse(raw_toml)
  end

  def self.read_file(file_path)
    TromlExt.parse(File.read(file_path))
  end
end
