require 'rubygems'
require 'rake'

# ------------------------------------------------
# TEST -------------------------------------------
# ------------------------------------------------
desc "Tests git-auto gem"

task :test do
  sh "rspec spec/git-auto_spec.rb"
end

# ------------------------------------------------
# UNINSTALL --------------------------------------
# ------------------------------------------------
desc "Uninstalls git-auto gem and executables"

task :uninstall do
  # FIX: This does not work because it's not loading rvm and such.
  #sh "gem uninstall git-auto --executables"
end

# ------------------------------------------------
# BUILD ------------------------------------------
# ------------------------------------------------
desc "Builds git-auto gem"

task :build do
  sh "gem build git-auto.gemspec"
end

# ------------------------------------------------
# INSTALL ----------------------------------------
# ------------------------------------------------
desc "Installs git-auto gem"

task :install do
  sh "gem install git-auto-0.0.1.gem"
end

desc "Uninstalls, Builds, and Installs git-auto gem"

# ------------------------------------------------
# DEFAULT ----------------------------------------
# ------------------------------------------------
task :default => [:uninstall, :build, :install]
