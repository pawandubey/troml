# frozen_string_literal: true

require_relative "troml/version"
require "rutie"
require "date"

module Troml
  # Class to encapsulate external functions defined in Rust
  # Must be defined before the call to Rutie#init as the Rust
  # library depends on its existence.
  #
  # @private
  class TromlExt; end

  class Error < StandardError; end

  class ExtParseError < Error; end

  # Initialize external library
  Rutie.new(:troml).init "Init_troml", __dir__

  # Returns a hash representation of the TOML string passed.
  # Raises on parse failure.
  #
  # @param raw_toml [String] The raw TOML as a string.
  #
  # @return [Hash] The hash representation of the TOML document, if valid.
  # @raise [Troml::ExtParseError] Raises if parsing fails.
  def self.parse(raw_toml)
    TromlExt.parse(raw_toml)
  end

  # Returns a hash representation of the TOML stored in the file
  # at the provided path.
  # Raises on parse failure or if the file is not present.
  #
  # @param file_path [String] Path to the file to be read.
  #
  # @return [Hash] The hash representation of the file's TOML content.
  # @raise [Troml::ExtParseError] Raises if parsing fails.
  def self.parse_file(file_path)
    TromlExt.parse(File.read(file_path))
  end

  private_constant :TromlExt
end
