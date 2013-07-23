require 'rubygems'
require 'rake'

desc "Tests git-auto gem"

task :test do
  sh "rspec spec/git-auto_spec.rb"
end

desc "Uninstalls git-auto gem and executables"

task :uninstall do
  sh "gem uninstall git-auto --executables"
end

desc "Builds git-auto gem"

task :build do
  sh "gem build git-auto.gemspec"
end

desc "Installs git-auto gem"

task :install do
  sh "gem install git-auto-0.0.0.gem"
end

desc "Uninstalls, Builds, and Installs git-auto gem"

task :default => [:uninstall, :build, :install]
