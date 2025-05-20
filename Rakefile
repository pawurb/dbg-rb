require "bundler/gem_tasks"
require "rake/testtask"
Rake::TestTask.new do |t|
  t.libs << "test"
end
desc "Run tests"
task :default => :test

task :test do
  system("bundle exec rspec spec/main_spec.rb")
  system("bundle exec rspec spec/inline_spec.rb")
end
