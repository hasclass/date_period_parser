# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'date_period_parser/version'

Gem::Specification.new do |spec|
  spec.name          = "date_period_parser"
  spec.version       = DatePeriodParser::VERSION
  spec.authors       = ["hasclass"]
  spec.email         = ["sebi.burkhard@gmail.com"]

  spec.summary       = %q{Parse a date-like string and returns it's start and end DateTime.}
  spec.description   = %q{Parse a date-like string and returns it's start and end DateTime.}
  spec.homepage      = "https://github.com/hasclass/date_period_parser"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.test_files = ["spec/date_period_parser_spec.rb"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
end
