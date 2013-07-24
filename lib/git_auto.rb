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

  self.commands   = []
  self.repository = false

  # ----------------------------------------------
  # USAGE ----------------------------------------
  # ----------------------------------------------
  def self.usage
    puts "usage: git-auto <action> [--dry-run]"

    self.commands.each do |command|
      puts command.usage
    end

    return 1
  end

  # ----------------------------------------------
  # MESSAGING ------------------------------------
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
      # "discover" will give you the path with .git... 
      #self.repository = Rugged::Repository.new(Rugged::Repository.discover("."))
      self.repository = Rugged::Repository.new(".")
    rescue Rugged::RepositoryError
      GitAuto.fatal "not a git repository (or any of the parent directories): .git", 128
    end
  end

  def self.commit(options={})

    options[:author] = { :email => "testuser@github.com", :name => 'Test Author', :time => Time.now }
    options[:committer] = { :email => "testuser@github.com", :name => 'Test Author', :time => Time.now }
    options[:message] ||= "Making a commit via Rugged!"
    options[:parents] = self.repository.empty? ? [] : [ self.repository.head.target ].compact
    options[:update_ref] = 'HEAD'

    Rugged::Commit.create(self.repository, options)
  end

  # ----------------------------------------------
  # MAIN -----------------------------------------
  # ----------------------------------------------
  def self.main

    # Initialize (and ensure) a Git repository or exit
    GitAuto.initialize_repository

    return GitAuto.auto if ARGV.length == 0

    # Find the Command and commit
    command = GitAuto.find_command_by_name(ARGV[0])

    # Ensure the command or exit
    GitAuto.fatal "Not a command" unless command

    # Commit based on the command
    command.commit

    # Successful exit
    exit 0
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
  def self.auto
    puts "auto"
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

    def commit
      #GitAuto.commit({message: commit_message})
      GitAuto.commit
    end

    def usage
      "   #{name}\t#{description}"
    end
  end

  # ----------------------------------------------
  # REGISTER->COMMANDS ---------------------------
  # ----------------------------------------------
  register_command :clean, "Cleaned"
  register_command :reorder, "Reordered"

end

