module GitAuto
  class Repository

    attr_accessor :git

    def initialize(path: ".", log: Logger.new(GitAuto.git_logger))
      @git = Git.open path, log: log
    end
  
    def modified_files
    `git diff-tree --no-commit-id --name-only -r HEAD`.split("\n")
    end
  
    def commit(message)
      @git.commit_all message
    end

    def untracked_files
      `git ls-files --other --exclude-standard`.split("\n")
    end

    def clean_work_tree?

      # Are there any file changes?
      return false unless system "git diff-files --quiet --ignore-submodules"

      # Are there any text changes?
      return false unless system "git diff-index --cached --quiet --ignore-submodules HEAD"

      # Are there any untracked files?
      return false unless untracked_files.length == 0
      
      # Repository is clean
      true
    end

    def diff
      # FIX: Not sure how to get the diff from the current state to HEAD with the git Gem
      `git diff --no-color`
    end

  end
end

