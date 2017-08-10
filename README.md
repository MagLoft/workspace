# Workspace for Ruby

> Simplified Files and Directories handling

[![CircleCI](https://circleci.com/gh/MagLoft/workspace/tree/master.svg?style=svg)](https://circleci.com/gh/MagLoft/workspace/tree/master)

## Description

Workspace makes it a breeze to work with files and directories.

## Synopsis

Workspace::Dir and Workspace::File are abstractions of the ruby Dir and File classes (although not extending them).

When working with files and folders, these abstractions can significantly help with keeping your code simple, consistent and easy to read.

```ruby
require "workspace"

root = Workspace.dir                        # initializes a workspace in the current directory
root = Workspace.tmpdir                     # initializes a new workspace in a temporary directory
                    
root.file("file.txt").write("hello world")  # creates the file "file.txt" with contents "hello world"
root.dir("dir").file("file.txt").create     # both the file "file.txt" and its parent directory "dir"
                    
root.dir("dir").exists?                     # => true
root.dir("dir").delete                      # deletes the physical file, but keeps the Workspace::Dir
root.dir("dir").exists?                     # => false

file = root.dir("dir1").file("file.txt")
file.relative_path(root.dir("dir2"))        # => "../dir1/file.txt"

root.dir("build").clean                     # delete and re-create directory

root.files                                  # [file1, file2, file3...]
root.directories                            # [dir1, dir2, dir3...]
root.children("**/*.rb")                    # [...] recursive matched files with .rb extension
```

## Installation
    
    # install globally
    gem install workspace
    
    # install using bundler / Gemfile
    gem "workspace"

## License

workspace is available under an MIT-style license.
