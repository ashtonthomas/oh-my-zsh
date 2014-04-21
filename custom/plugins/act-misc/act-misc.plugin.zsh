alias hk="heroku"     # shortcut for heroku commands

alias c="clear"

# Location aliases
alias h="cd ~" # There's no place like home...

# A helper command to set up a base ruby, git, bundler, rvm project
setuparubyproject(){

  if [[ -z "$1" ]]; then

    echo "Please provide a project name:$ setuparubyproject <project-name-here>"

    return

  fi

  if [ -d "$1" ]; then
    # This project or directory already exists

    echo "The $1 directory or project already exists."

    return
  fi

  echo "Setting up a new standard project:" $1


  mkdir $1
  echo "directory $1 created"

  cd $1
  echo "moving into directory"

  touch README
  echo "Simple ruby project." >> README
  echo "created README"

  touch Gemfile
  echo "source 'https://rubygems.org'\n\nruby '2.0.0'\n\n#gem 'chronic'" >> Gemfile
  echo "created Gemfile"

  touch .ruby_version
  echo "2.0.0" >> .ruby_version
  echo "created .ruby_version"

  touch .ruby_gemset
  echo "default" >> .ruby_gemset
  echo "created .ruby_gemset"

  touch .gitignore
  echo "created .gitignore"

  # leave directory and come back int o activate RVM
  ..
  cd $1

  # initialize git
  git init

  # run bundler to set up dependencies
  bundle

  # Let's go ahead and initialize a git repo and do a first commit
  git add .
  git commit -m "setting up base ruby project with bundler and rvm"

  gst

  atom .

}
