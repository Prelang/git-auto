require "active_support/all"

module GitAuto
  mattr_accessor :commands

  self.commands = []

  def self.usage
    puts "usage: git-auto"
    return 1
  end

  def self.main
    return GitAuto.usage if ARGV.length == 0

    # Chop off the GitAuto command name
    shifted = ARGV[1..ARGV.length]

    return GitAuto.usage
  end

end

