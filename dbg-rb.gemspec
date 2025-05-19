# -*- encoding: utf-8 -*-
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "dbg_rb/version"

Gem::Specification.new do |s|
  s.name = "dbg-rb"
  s.version = DbgRb::VERSION
  s.authors = ["pawurb"]
  s.email = ["contact@pawelurbanek.com"]
  s.summary = "Simple debugging helper"
  s.description = "Rust-inspired, puts debugging helper, adding caller info and optional coloring."
  s.homepage = "http://github.com/pawurb/dbg-rb"
  s.files = `git ls-files`.split("\n").reject { |f| f.match?(/\.db$/) }
  s.require_paths = ["lib"]
  s.license = "MIT"
  s.add_dependency "json"
  s.add_development_dependency "ostruct"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rufo"

  if s.respond_to?(:metadata=)
    s.metadata = { "rubygems_mfa_required" => "true" }
  end
end
