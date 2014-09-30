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
  def self.auto(arguments=[])
    # TODO: Try to detect if a new function was added and commit with:
    # "Added functionName() to foo.js"
    #
    # TODO: If the diff has a block commented, you could try to find the
    # functions that were commented then make a commit with:
    # "Commented foo(), bar() block in foo.js"
    #
    # TODO: If the user has removed a function, try to detect it and commit
    # with:
    # "Removed foo() from foo.js"
    #
    # TODO: You could detect if a user has changed the arguments to a function.
    puts "auto"
  end

  # ----------------------------------------------
  # FORMATTED ------------------------------------
  # ----------------------------------------------
  def self.formatted_commit(arguments)
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
  register_command :clean, "Cleaned"
  register_command :typo, "Fixed typo"
  register_command :comment, "Commented"
  register_command :dryed, "DRYed"
  register_command :reorder, "Reordered"
  register_command :wording, "Changed wording"
  register_command :formatting, "Changed formatting"
  register_command :consolidated, "Consolidated"
  register_command :fixed, "Fixed" # TODO: Detect if a function, variable, CSS, etc. was fixed
  register_command :idea, "Added idea"
  register_command :renamed_function, "Renamed function"
  # IDEA: You could keep track of ~/.history and make a commit with "the
  # commands that have been issued since the last commit".
  #
  #
  #register_command :start_of_function
  #register_command :start_of_view

  # etc... Or just do this by passing in flags: "s<tart> f<unction> u<ntested>
  # functionName
  # (tab completed)
  #
  #
  # IDEA: If the auto command is "relations-between" you could see if two files
  # were edited and then make the commit: "relations between foo.rb and bar.rb"
  #
  # style_for #foo
  #
  #
  # IDEA: You could add in a hook somewhere to detect files that git-auto knows
  # should be committed like migrations.
  #
  # :purged
  #
  # IDEA: If you had a bank of elements to choose from (maybe extract from CSS?)
  # you could autocomplete them in the git-auto CLI.
  #
  # e.g., "changed height to match header on #some_div"
  #
  #
  # git auto organized
  #
  #
  #FIX: Make the commands generate on a post-commit hook

  #* moved files
  #* removed files
  #* added files

  #Have git-auto attempt to guess your commit (Warning: basic):

      #$ git auto

  #Pass multiple actions:

      #$ git auto cleaned reordered

  #Go file-by-file:

      #$ git auto each

  #Define your own actions:


end

require "git_auto/repository"
