# frozen_string_literal: true

require_relative "lib/troml/version"

Gem::Specification.new do |spec|
  spec.name = "troml"
  spec.version = Troml::VERSION
  spec.authors = ["Pawan Dubey"]
  spec.email = ["git@pawandubey.com"]

  spec.summary = "TOML parser"
  spec.description = spec.summary
  spec.homepage = "https://github.com/pawandubey/troml"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.2"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/tree/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rutie"

  spec.add_development_dependency "yard"
  spec.add_development_dependency "gem-release"
end
