require "active_support/all"
require "git"
require "pry"

# ================================================
# MODULE->GIT-AUTO ===============================
# ================================================
module GitAuto

  # ----------------------------------------------
  # ATTRIBUTES -----------------------------------
  # ----------------------------------------------
  mattr_accessor :commands, :repository

  self.commands   = []
  self.repository = false

  # ----------------------------------------------
  # USAGE ----------------------------------------
  # ----------------------------------------------
  def self.usage
    puts "usage: git-auto <action|message> [--dry-run]"

    self.commands.each do |command|
      puts command.usage
    end

    return 1
  end

  # ----------------------------------------------
  # MESSAGING ------------------------------------
  # ----------------------------------------------
  def self.fatal(message, error_code: 1, show_fatal: true)

    prefix = ""
    prefix = "fatal: " if show_fatal

    puts "git-auto: #{prefix}#{message}"

    exit error_code
  end
  
  def self.warning(message, error_code: nil, show_warning: true)

    prefix = ""
    prefix = "warning: " if show_warning

    puts "git-auto: #{prefix}#{message}"

    exit error_code if error_code
  end

  # ----------------------------------------------
  # GIT ------------------------------------------
  # ----------------------------------------------
  
  # TEMPORARY: Remove logging
  def self.git_logger
    STDOUT
    nil
  end

  def self.initialize_repository
    begin
      self.repository = GitAuto::Repository.new
    rescue ArgumentError
      GitAuto.fatal "not a git repository (or any of the parent directories): .git", error_code: 128
    end
  end

  # ----------------------------------------------
  # MAIN -----------------------------------------
  # ----------------------------------------------
  def self.main

    # Initialize (and ensure) a Git repository or exit
    GitAuto.initialize_repository

    # Ensure that we do have an unclean repository
    GitAuto.fatal "nothing to commit, working directory clean", show_fatal: false if repository.clean_work_tree?

    # No arguments so just invoke 'auto'
    return GitAuto.auto if ARGV.length == 0

    # We have arguments. Extract all of the commands and the formatted message.
    commands = []
    message  = false

    ARGV.each_with_index do |argument, index|

      # The argument is a Command
      if argument.start_with? ":"

        if command = find_command_by_name(argument[1, argument.length-1])
          commands << command
        else
          warning "Could not find command for command argument '#{argument}'. Skipping."
        end

        next
      end

      # The argument is not a Command. Check if it's a valid formatted commit message.
      # If it's the last argument, consider it valid.
      if index == (ARGV.length-1)
        message = argument
        break
      end

      warning "Argument is not a command but is not the last argument (formatted commit message). Skipping."
    end

    # Now we can pass commands and message to 'auto'
    auto message: message, commands: commands
    
  end
  
  # ----------------------------------------------
  # FIND -----------------------------------------
  # ----------------------------------------------
  def self.find_command_by_name(name)
    self.commands.select { |command| command.name.to_s == name }.first
  end

  # ----------------------------------------------
  # AUTO -----------------------------------------
  # ----------------------------------------------
  def self.auto(message: nil, commands: [])


    puts commands
    puts message

  end

  # ----------------------------------------------
  # FORMATTED ------------------------------------
  # ----------------------------------------------
  def self.formatted_commit_message(message)
  end

  # ----------------------------------------------
  # REGISTRATION ---------------------------------
  # ----------------------------------------------
  def self.register_command(*arguments)
    self.commands << Command.new(*arguments)
  end

  # ----------------------------------------------
  # CLASS->COMMAND -------------------------------
  # ----------------------------------------------
  class Command
    attr_accessor :name, :description

    def initialize(name, description)
      @name = name
      @description = description
    end

    def commit_message
      "#{@name}"
    end

    def execute(arguments)
      puts "Executing: #{name} sub command with arguments: #{arguments}"
    end

    def commit
      GitAuto.commit commit_message
    end

    def usage
      "   #{name}\t#{description}"
    end
  end

  # ----------------------------------------------
  # REGISTER->COMMANDS ---------------------------
  # ----------------------------------------------
  register_command :+,       "Adds"
  register_command :-,       "Removes"
  register_command :renames, "Renames"
  register_command :moves,   "Moves"

end

require "git_auto/repository"
