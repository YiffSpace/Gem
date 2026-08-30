# frozen_string_literal: true

require_relative("lib/yiffspace/tables/version")

Gem::Specification.new do |spec|
  spec.name                  = "yiffspace-tables"
  spec.version               = YiffSpace::Tables::VERSION
  spec.authors               = ["Donovan_DMC"]
  spec.email                 = ["hewwo@yiff.rocks"]
  spec.homepage              = "https://yiff.space"
  spec.summary               = "HTML table-building DSL (YiffSpace::Tables::Builder), for https://yiff.space and related projects"
  spec.description           = spec.summary
  spec.license               = "MIT"
  spec.required_ruby_version = ">= 3.4.1"

  spec.metadata["allowed_push_host"]     = "https://rubygems.org"
  spec.metadata["homepage_uri"]          = spec.homepage
  spec.metadata["source_code_uri"]       = "https://github.com/YiffSpace/Gem/tree/master/yiffspace-tables"
  spec.metadata["changelog_uri"]         = "https://github.com/YiffSpace/Gem/blob/master/yiffspace-tables/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["lib/**/*", "LICENSE", "Rakefile", "README.md", "CHANGELOG.md"]
  end

  spec.add_dependency("yiffspace-core", ">= 0.2.0")
  spec.add_dependency("zeitwerk", ">= 2.6")
end
