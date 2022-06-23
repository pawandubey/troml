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
  #
  # This is a hack to work around the weirdness of developing
  # a Rust extension while relying on Rubygems' native Cargo builder.
  # Rubygems builds copies the shared object into the gem's lib directory
  # when gem install is run, so it's available for loading in.
  #
  # However, while developing the gem, we want to be able to run the gem from its
  # source context, so we rely on Rutie's convention of loading the shared object
  # built by Cargo.
  if File.exist?("troml.so")
    # We are running in "installed" mode.
    # Load the shared object built by rubygems.
    require "troml.so"
  else
    # Otherwise we are running in "dev" mode.
    # Load the target/release object via Rutie.
    Rutie.new(:troml).init "Init_troml", __dir__
  end

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
