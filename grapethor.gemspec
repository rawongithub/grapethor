
lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "grapethor/version"

Gem::Specification.new do |spec|
  spec.name          = "grapethor"
  spec.version       = Grapethor::VERSION
  spec.authors       = ["Rafal Wrzochol"]
  spec.email         = ["rafal.wrzochol@gmail.com"]

  spec.summary       = %q{Grape API generator}
  spec.description   = %q{Grape REST-like API application generator based on Thor.}
  spec.homepage      = "https://rawongithub.github.io/grapethor/"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/rawongithub/grapethor"
    spec.metadata["changelog_uri"] = "https://github.com/rawongithub/grapethor/blob/master/CHANGELOG.md"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.required_ruby_version = '>= 2.5.3'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^#{spec.bindir}/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "thor", "~> 0.20"
  spec.add_dependency "activesupport", "~> 5.2"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "minitest", "~> 5.11"
  spec.add_development_dependency "minitest-reporters", "~> 1.3"
  spec.add_development_dependency 'simplecov', "~> 0.16"
end
