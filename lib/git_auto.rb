require "active_support/all"
require "rugged"

# ================================================
# MODULE->GIT-AUTO ===============================
# ================================================
module GitAuto

  # ----------------------------------------------
  # ATTRIBUTES -----------------------------------
  # ----------------------------------------------
  mattr_accessor :commands

  self.commands = []

  # ----------------------------------------------
  # USAGE ----------------------------------------
  # ----------------------------------------------
  def self.usage
    puts "usage: git-auto"

    self.commands.each do |command|
      puts command.name
    end

    return 1
  end

  # ----------------------------------------------
  # MAIN -----------------------------------------
  # ----------------------------------------------
  def self.main
    return GitAuto.auto if ARGV.length == 0

    # Chop off the GitAuto command name
    shifted = ARGV[1..ARGV.length]

    return GitAuto.usage
  end

  # ----------------------------------------------
  # AUTO -----------------------------------------
  # ----------------------------------------------
  def self.auto
    puts "auto"
  end

  # ----------------------------------------------
  # REGISTRATION ---------------------------------
  # ----------------------------------------------
  def self.register_command(name, &block)
    command = Command.new
    command.name = name

    self.commands << command
  end

  # ----------------------------------------------
  # CLASS->COMMAND -------------------------------
  # ----------------------------------------------
  class Command
    attr_accessor :name, :description
  end

  # ----------------------------------------------
  # REGISTER->COMMANDS ---------------------------
  # ----------------------------------------------
  register_command :cleaned do
  end

end

