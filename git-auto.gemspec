# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'git_auto/version'

Gem::Specification.new do |spec|
  spec.name          = "git-auto"
  spec.version       = GitAuto::VERSION
  spec.authors       = ["Erik Nomitch"]
  spec.email         = ["erik@nomitch.com"]
  spec.description   = "Description"
  spec.summary       = "Summary"
  spec.homepage      = "https://github.com/Prelang/git-auto"
  spec.licenses      = ["GPL-2.0"]

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activesupport", "~> 4.1", "= 4.1.4"
  spec.add_runtime_dependency "git",           "~> 1.2", "~> 1.2.8"
end
