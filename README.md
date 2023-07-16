# UNIX Setup

Lightweight installation scripts manager for unix systems.

## Usage

```shell
#> ./unixsetup.sh -h
Usage:
-h        Print help message an exit
-l        List all available installation packages
-c        List all candidate packages to be installed with -a option
-s        Status check: Lookup for already installed packages
[-e NAME] Check if a specific package exists and its installation status
[-i NAME] Install a specific package
[-u NAME] Uninstall a specific package
-a        Install all candidate packages
```

## Idea

Many years ago I was using different Debian systems as well as Mac systems
for development and was often switching between `bash` and `zsh`.
I needed a way to set up and configure my development environment
on a fresh newly installed system preferably with a one-line command.  
This is how `unix-setup v1` was implemented. It is simply a script
that executes other small installation scripts to install packages
on Debian and Darwin(Mac) systems. Most of the scripts use `apt-get` or `brew`
respectively to install packages, but they usually do some additional
configuration and customization.

While the newer version `unix-setup v2` focuses exclusively on Mac support
with `zsh` as a default shell only - it adds more control, flexibility
and reversibility over the package installation.  
But enough words, let's see real examples.

## Examples
Imagine that you want to install `jenv` - manager for JVM environments.
It can be as simple as running

```bash
brew install jenv
```

At the end of a successful installation, you will get something like this:

```shell
#> brew install jenv
...
==> Caveats
To activate jenv, add the following to your shell profile e.g. ~/.profile
or ~/.zshrc:
  export PATH="$HOME/.jenv/bin:$PATH"
  eval "$(jenv init -)"
...
```

So it still requires manual work to do to finish the installation.
Let's assume we will use only `zsh` as our shell and let's automate this
process a little bit with a script `jenv.sh`:

```shell
#> cat jenv.sh
#!/bin/bash

brew install jenv
echo 'export PATH="$HOME/.jenv/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(jenv init -)"' >> ~/.zshrc
```

To avoid polluting `.zshrc` config on re-installation it's safer to write:

```shell
#!/bin/bash

brew install jenv
if ! grep 'jenv init' ~/.zshrc &> /dev/null; then
  echo 'export PATH="$HOME/.jenv/bin:$PATH"' >> ~/.zshrc
  echo 'eval "$(jenv init -)"' >> ~/.zshrc
fi
```

You can go further and also check if `zsh` is installed
and `~/.zshrc` file exists, or you can extend this to apply changes
to bash `~/.profile` or `~/.bashrc` configs, but for me this script
looks fine as it is.

Now if you have a lot of these small scripts and want to install then
simultaneously and not manually one-by-one you need some kind of master
script. That's exactly how `unix-setup v1` was built.

If you add `jenv` to the `CANDIDATES`
list inside `install.sh`  like this:

```shell
#!/bin/bash
...
CANDIDATES=(
  ...
  oh-my-tmux
  jenv
)
```

and run it `./install.sh` the script will:
1. Go through the list of `CANDIDATES`
2. Try to find an appropriate script for a candidate within a root folder (in our case `./jenv.sh` for `jenv`)
3. Execute these scripts one by one and print statistics for installed/failed scripts.

A pretty straightforward way to set up your new system.

While the first version of the tool did job well for a fresh system
it was a little complicated to use after the initial installation.
To avoid redundant re-installation of packages you had to
either comment already installed packages in `CANDIDATES` list:

```shell
...
CANDIDATES=(
  ...
  # oh-my-tmux - is not going to be re-installed
  jenv
)
```

or use a specific script directly. Also, there was
no way to justify whether a particular package was installed or
not - you had to check it manually.

## V2

### Master script

A new version `unix-setup v2` was created to face those issues. Let's see what
that new `v2` master script does. From now on we will use the term *packages* for
slave installation scripts.

```shell
#> ./unixsetup.sh
Usage:
  -h        Print help message an exit
  -l        List all available installation packages
  -c        List all candidate packages to be installed with -a option
  -s        Status check: Lookup for already installed packages
  [-e NAME] Check if a specific package exists and its installation status
  [-i NAME] Install a specific package
  [-u NAME] Uninstall a specific package
  -a        Install all candidate packages
```

So we still can install all candidates simultaneously
by running `./unixsetup.sh -i`.
But now we can also look up all candidates that are going to be installed
together without reading a master file (`-c` option). Besides that, we can also
list all available packages that can be installed with this tool (`-l`).
We can also install (`-i`) or uninstall (`-u`) a particular package by name
and check if a package is installed (`-e`) or even list all currently installed
packages in the system (`-s`).

### Package implementation

To make this possible we need to reimplement installation scripts (packages)
in a different way.
Scripts for `v1` could be any kind of bash script, but
for `v2` they have to follow a specific format. Let's reimplement the previous
example in a new way.

To make things simpler we will start from a predefined example.

```shell
cp ./packages/example.sh ./packages/jenv.sh
```

Let's look inside that script.

```shell
#> cat ./packages/jenv.sh
#!/bin/bash

# The name of a package to be installed
PACKAGE_NAME="example"

# A list of configuration files that should be liked with .dotfiles repo
CONFIGURATION_FILES=()

# Imports
source src/prettyecho

# A check of whether current package is already installed in a system
# Expected to success if package is installed of fail otherwise
already_installed() {
  log_warning "Installation check is not implemented for $(bold $PACKAGE_NAME)!"
  exit 126
  # command -v <example> &> /dev/null
}

# An installation process must be implemented here
install() {
  log_warning "Installation process is not implemented for $(bold $PACKAGE_NAME)!"
  exit 126
  # log_info "Installing $(bold $PACKAGE_NAME) ..."
}

# An uninstallation process should be implemented here
uninstall() {
  log_warning "Uninstall process is not implemented for $(bold $PACKAGE_NAME)!"
  exit 126
  # log_info "Uninstalling $(bold $PACKAGE_NAME) ..."
}

# Returns a list of configuration files that should be liked with .dotfiles repo
configuration_files() {
  echo "${CONFIGURATION_FILES[@]}"
}


main() {
  case $1 in
    already_installed*)   already_installed;;
    install*)             install;;
    uninstall*)           uninstall;;
    configuration_files*) configuration_files;;
    *)
      echo "Command is missing or wrong. One of 'already_installed' 'install' 'uninstall' 'configuration_files' command is expected!"
      exit 1
  esac
}

main "$@"
```
#### Installation

Let's change `PACKAGE_NAME` variable to `jenv` and try to install `jenv` package:

```shell
#> ./unixsetup.sh -l
  ...
  jenv
  ...
  
#> ./unixsetup.sh -i jenv
[WARNING] Installation check is not implemented for jenv!
Package example installation status can't be checked!
Do you want to install it anyway? [Y/n] Y
Password:
Sudo was granted!
[WARNING] Installation process is not implemented for jenv!
[ERROR] Failed to install jenv because installation is not implemented
[ERROR] Check ./packages/jenv.sh file!
```

So master script `./unixsetup.sh` works properly with `jenv` package it just
can't really do anything because nothing is implemented inside that package.
Let's add the same script lines from `v1` example into `install` method
and try again.

```shell
#> cat ./packages/jenv.sh
#!/bin/bash

# The name of a package to be installed
PACKAGE_NAME="jenv"
...
# An installation process must be implemented here
install() {
  log_info "Installing $(bold $PACKAGE_NAME) ..."
  brew install jenv
  if ! grep 'jenv init' ~/.zshrc &> /dev/null; then
    echo 'export PATH="$HOME/.jenv/bin:$PATH"' >> ~/.zshrc
    echo 'eval "$(jenv init -)"' >> ~/.zshrc
  fi
}
...
main "$@"

#> ./unixsetup.sh -i jenv
[WARNING] Installation check is not implemented for jenv!
Package example installation status can't be checked!
Do you want to install it anyway? [Y/n] Y
Password:
Sudo was granted!
[INFO] Installating jenv ...
==> Downloading https://formulae.brew.sh/api/formula.jws.json
...
[SUCCESS] Package jenv successfully installed

#> jenv -h
jenv 0.5.6
Usage: jenv <command> [<args>]
...
```

#### Uninstallation

To get rid of warnings we can implement `uninstall` and `already_installed`
methods as well.

```shell
#> cat ./packages/jenv.sh
#!/bin/bash

# The name of a package to be installed
PACKAGE_NAME="stub"
...
# A check of whether the current package is already installed in a system
# Expected to succeed if a package is installed or fails otherwise
already_installed() {
   command -v jenv &> /dev/null
}
...
# An uninstallation process should be implemented here
uninstall() {
  log_info "Uninstalling $(bold $PACKAGE_NAME) ..."
  brew uninstall jenv
}
...

main "$@"

#> ./unixsetup.sh -i jenv
[INFO] Package jenv is already installed, skipping...

#> ./unixsetup.sh -u jenv
[INFO] Package jenv is installed. Uninstalling...
[INFO] Uninstalling jenv ...
Uninstalling /usr/local/Cellar/jenv/0.5.6... (86 files, 78KB)
[SUCCESS] Package jenv successfully uninstalled
```

#### Configuration files

This method is already implemented, and it is just a getter for
`CONFIGURATION_FILES` variable. The default value for this variable is an empty list,
and you can leave it this way it will not affect your installation logic in any way.
Sometimes packages can create important configurations which are better to be saved
in some private repository to reuse later. For example `~/.zshrc`, `~/.profile`,
`~/.tmux`, `~/.vimrc`, etc. These are usually carefully managed configurations with
a lot of plugins, customizations, aliases, and many more. If you add these files to
`CONFIGURATION_FILES` list a system will move these files to a `~/.dotfiles` dir
and replace them with symlinks. You can then link `~/.dotfiles` to your private remote
repo and manage them with Git. For implementation details refer to [dotfiles](src/dotfiles)