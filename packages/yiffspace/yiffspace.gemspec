# frozen_string_literal: true

require_relative("lib/yiffspace/version")

Gem::Specification.new do |spec|
  spec.name                  = "yiffspace"
  spec.version               = YiffSpace::VERSION
  spec.authors               = ["Donovan_DMC"]
  spec.email                 = ["hewwo@yiff.rocks"]
  spec.homepage              = "https://yiff.space"
  spec.summary               = "Depends on every yiffspace-* gem, for https://yiff.space and related projects"
  spec.description           = spec.summary
  spec.license               = "MIT"
  spec.required_ruby_version = ">= 3.4.1"

  spec.metadata["allowed_push_host"]     = "https://rubygems.org"
  spec.metadata["homepage_uri"]          = spec.homepage
  spec.metadata["source_code_uri"]       = "https://github.com/YiffSpace/Gem"
  spec.metadata["changelog_uri"]         = "https://github.com/YiffSpace/Gem/blob/master/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["lib/**/*", "LICENSE", "Rakefile", "README.md", "CHANGELOG.md"]
  end

  spec.add_dependency("yiffspace-arel", ">= 0.0.1")
  spec.add_dependency("yiffspace-auth", ">= 0.0.1")
  spec.add_dependency("yiffspace-config", ">= 0.0.1")
  spec.add_dependency("yiffspace-core", ">= 0.2.0")
  spec.add_dependency("yiffspace-ext", ">= 0.0.1")
  spec.add_dependency("yiffspace-fixers", ">= 0.0.1")
  spec.add_dependency("yiffspace-images", ">= 0.0.1")
  spec.add_dependency("yiffspace-include", ">= 0.0.1")
  spec.add_dependency("yiffspace-search", ">= 0.0.1")
  spec.add_dependency("yiffspace-tables", ">= 0.0.1")
  spec.add_dependency("yiffspace-user", ">= 0.0.1")
end
