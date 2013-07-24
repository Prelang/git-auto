# GitAuto

## Installation

Add this line to your application's Gemfile:

    gem 'git-auto'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install git-auto

## Usage

FIX: Make this generate on a post-commit hook
* cleaned:clean
* reordered:reorder
* commented:comment
* fixed-typo:typo
* changed-wording:wording
* changed-formatting:formatting
* changed-spacing:spacing
* downsized:downsized
* optimized:optimized
* removed-whitespace:whitespace

* moved files
* removed files
* added files

Have git-auto attempt to guess your commit (Warning: basic):

    $ git auto

Pass multiple actions:

    $ git auto cleaned reordered

Go file-by-file:

    $ git auto each

Define your own actions:

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
