# -*- encoding: utf-8 -*-
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ruby_dbg/version"

Gem::Specification.new do |s|
  s.name = "ruby-dbg"
  s.version = RubyDBG::VERSION
  s.authors = ["pawurb"]
  s.email = ["contact@pawelurbanek.com"]
  s.summary = "Simple debuging helper"
  s.description = "Rust-inspired, puts debugging helper, adding caller info and optional coloring."
  s.homepage = "http://github.com/pawurb/ruby-dbg"
  s.files = `git ls-files`.split("\n").reject { |f| f.match?(/\.db$/) }
  s.require_paths = ["lib"]
  s.license = "MIT"
  s.add_dependency "binding_of_caller"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rufo"

  if s.respond_to?(:metadata=)
    s.metadata = { "rubygems_mfa_required" => "true" }
  end
end
