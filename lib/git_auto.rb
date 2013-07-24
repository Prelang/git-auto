require "active_support/all"
require "rugged"

# ================================================
# MODULE->GIT-AUTO ===============================
# ================================================
module GitAuto

  # ----------------------------------------------
  # ATTRIBUTES -----------------------------------
  # ----------------------------------------------
  mattr_accessor :commands, :repository

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
  # ERRORS ---------------------------------------
  # ----------------------------------------------
  def self.fatal(message, error_code=1)
    puts "fatal: #{message}"
    exit error_code
  end

  # ----------------------------------------------
  # GIT ------------------------------------------
  # ----------------------------------------------
  def self.initialize_repository

    begin
      self.repository = Rugged::Repository.discover(".")
      true
    rescue Rugged::RepositoryError
      GitAuto.fatal("not a git repository (or any of the parent directories): .git")
    end
  end

  # ----------------------------------------------
  # MAIN -----------------------------------------
  # ----------------------------------------------
  def self.main

    GitAuto.initialize_repository

    #return gitauto.fatal("not a git repository (or any of the parent directories): .git") unless repo.empty?

    return GitAuto.auto if ARGV.length == 0

    # Find the Command
    command = GitAuto.find_command_by_name(ARGV[0])

    command.commit

    # Chop off the GitAuto command name
    #shifted = ARGV[1..ARGV.length]

    #return GitAuto.usage
  end
  
  # ----------------------------------------------
  # FIND -----------------------------------------
  # ----------------------------------------------
  def find_command_by_name(name)
    self.commands.select { |command| command.name == name }
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

    def commit
      puts "commiting #{@name}"
    end
  end

  # ----------------------------------------------
  # REGISTER->COMMANDS ---------------------------
  # ----------------------------------------------
  register_command :cleaned do
  end

end

