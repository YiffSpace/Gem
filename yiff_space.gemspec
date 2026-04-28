# frozen_string_literal: true

require_relative("lib/yiff_space/version")

Gem::Specification.new do |spec|
  spec.name                  = "yiff_space"
  spec.version               = YiffSpace::VERSION
  spec.authors               = ["Donovan_DMC"]
  spec.email                 = ["hewwo@yiff.rocks"]
  spec.homepage              = "https://yiff.space"
  spec.summary               = "Collection of ruby code for https://yiff.space and related projects"
  spec.description           = "Collection of ruby code for https://yiff.space and related projects"
  spec.license               = "MIT"
  spec.required_ruby_version = ">= 3.4"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "none"

  spec.metadata["homepage_uri"]          = spec.homepage
  spec.metadata["source_code_uri"]       = "https://github.com/YiffSpace/Gem"
  spec.metadata["changelog_uri"]         = "https://github.com/YiffSpace/Gem/blob/master/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,engines,lib}/**/*", "LICENSE", "Rakefile", "README.md", "CHANGELOG.md"]
  end

  spec.add_dependency("httparty", ">= 0.24")
  spec.add_dependency("openid_connect", ">= 2.3")
  spec.add_dependency("rails", ">= 7.1")
  spec.add_dependency("zeitwerk", ">= 2.6")
end
