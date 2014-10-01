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
      fatal "not a git repository (or any of the parent directories): .git", error_code: 128
    end
  end

  # ----------------------------------------------
  # MAIN -----------------------------------------
  # ----------------------------------------------
  def self.main

    # Initialize (and ensure) a Git repository or exit
    initialize_repository

    # Ensure that we do have an unclean repository
    fatal "nothing to commit, working directory clean", show_fatal: false if repository.clean_work_tree?

    # No arguments so just invoke 'auto'
    return auto if ARGV.length == 0

    # We have arguments. Extract all of the commands and the formatted message.
    commands = []
    message  = false

    ARGV.each_with_index do |argument, index|

      # The argument is a Command
      if command = find_command_by_match(argument)
        commands << command
        next
      end

      # The argument is not a Command. Check if it's a valid formatted commit message.
      # If it's the last argument, consider it valid.
      if index == (ARGV.length-1)
        message = argument.dup
        break
      end

      warning "Argument '#{argument}' is not a valid command but is not the last argument (formatted commit message). Skipping."
    end

    # Now we can pass commands and message to 'auto'
    auto message: message, commands: commands
    
  end
  
  # ----------------------------------------------
  # FIND -----------------------------------------
  # ----------------------------------------------
  def self.find_command_by_match(match)
    self.commands.select { |command| command.match.to_s == match }.first
  end

  # ----------------------------------------------
  # AUTO -----------------------------------------
  # ----------------------------------------------
  def self.auto(message: nil, commands: [])

    # TEMPORARY:
    return nil unless message

    # TEMPORARY:
    prefix = ""

    if command = commands.first
      prefix = "#{command.output} "
    end

    puts "#{prefix}#{format_message(message)}"
  end

  # ----------------------------------------------
  # FORMATTING -----------------------------------
  # ----------------------------------------------
  def self.replacement_definitions
    {
      # Files modified (basenames)
      ":f"  => lambda { repository.modified_files(basename_only: true).join(", ") },

      # Most modified file's basename
      ":f*" => lambda { "FIX" }
    }
  end

  def self.format_message(message)

    # Search and replace
    replacement_definitions.each do |search, replace|
      message.gsub! search, replace.call
    end

    message
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
    attr_accessor :match, :verb

    def initialize(match, verb)
      @match = match
      @verb  = verb
    end

    def output
      verb
    end

    def usage
      "   #{match}\t#{verb}"
    end
  end

  # ----------------------------------------------
  # REGISTER->COMMANDS ---------------------------
  # ----------------------------------------------
  register_command "+",        "Adds"
  register_command "-",        "Removes"
  register_command ":renames", "Renames"
  register_command ":moves",   "Moves"

end

require "git_auto/repository"
