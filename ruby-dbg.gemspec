# -*- encoding: utf-8 -*-
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ruby_dbg/version"

Gem::Specification.new do |s|
  s.name = "ruby-dbg"
  s.version = RubyDBG::VERSION
  s.authors = ["pawurb"]
  s.email = ["contact@pawelurbanek.com"]
  s.summary = %q{ Simple debug helper }
  s.description = %q{ Puts debugging helper, adding file context info and optional coloring. }
  s.homepage = "http://github.com/pawurb/ruby-dbg"
  s.files = `git ls-files`.split("\n").reject { |f| f.match?(/\.db$/) }
  s.test_files = s.files.grep(%r{^(spec)/})
  s.require_paths = ["lib"]
  s.license = "MIT"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rufo"

  if s.respond_to?(:metadata=)
    s.metadata = { "rubygems_mfa_required" => "true" }
  end
end
