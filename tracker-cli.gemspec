# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tracker/cli/version'

Gem::Specification.new do |spec|
  spec.name          = "tracker-cli"
  spec.version       = Tracker::Cli::VERSION
  spec.authors       = ["Benjamin Bergstein"]
  spec.email         = ["bennyjbergstein@gmail.com"]

  spec.summary       = "A mostly for-fun Command Line Interface (CLI) for Pivotal Tracker"
  spec.description   = "Supports listing/fetching stories and projects"
  spec.homepage      = "https://github.com/benastan/tracker-cli"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  
  spec.bindir        = "bin"
  spec.executables << 'tracker'
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'webmock'

  spec.add_dependency 'faraday'
  spec.add_dependency 'faraday_middleware'

end
