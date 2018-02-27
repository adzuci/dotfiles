#!/usr/bin/env bash

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install command-line tools using Homebrew.

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils

# Misc Work
brew install terraform
brew install awscli

# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed --with-default-names
# Install Bash 4.
# Note: don’t forget to add `/usr/local/bin/bash` to `/etc/shells` before
# running `chsh`.
curl -L git.io/antigen > antigen.zsh
brew install bash
brew install bash-completion2
brew install zsh zsh-completions
cd ~ && git clone https://github.com/zsh-users/antigen.git .antigen
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
brew cask install spectacle
brew install tmux
gem install tmuxinator
brew install reattach-to-user-namespace
brew install mr
brew cask install sublime-text
brew cask install virtualbox
brew install docker
brew cask install docker
brew cask install spotify
brew cask install caffeine
brew cask install tunnelblick
brew cask install the-unarchiver
brew install htop
brew cask install istat-menus
brew cask install iterm2
brew install telnet

# Code
brew install python
brew install python3
sudo easy_install pip
sudo pip install --upgrade pip
pip3 install --upgrade pip setuptools wheel
pip3 install virtualenv virtualenvwrapper

curl -L https://get.rvm.io | bash -s stable --rails --autolibs=enabled


# Finder settings
defaults write com.apple.finder AppleShowAllFiles YES


# Switch to using brew-installed bash as default shell
if ! fgrep -q '/usr/local/bin/bash' /etc/shells; then
  echo '/usr/local/bin/bash' | sudo tee -a /etc/shells;
  chsh -s /usr/local/bin/bash;
fi;

# Install `wget` with IRI support.
brew install wget --with-iri

# Install GnuPG to enable PGP-signing commits.
brew install gnupg

# Install more recent versions of some macOS tools.
brew install vim --with-override-system-vi
brew install grep
brew install openssh
brew install screen
brew install homebrew/php/php56 --with-gmp

# Install font tools.
brew tap bramstein/webfonttools
brew install sfnt2woff
brew install sfnt2woff-zopfli
brew install woff2

# Install some CTF tools; see https://github.com/ctfs/write-ups.
brew install aircrack-ng
brew install bfg
brew install binutils
brew install binwalk
brew install cifer
brew install dex2jar
brew install dns2tcp
brew install fcrackzip
brew install foremost
brew install hashpump
brew install hydra
brew install john
brew install knock
brew install netpbm
brew install nmap
brew install pngcheck
brew install socat
brew install sqlmap
brew install tcpflow
brew install tcpreplay
brew install tcptrace
brew install ucspi-tcp # `tcpserver` etc.
brew install xpdf
brew install xz

# Install other useful binaries.
brew install ack
#brew install exiv2
brew install git
brew install git-lfs
brew install imagemagick --with-webp
brew install lua
brew install lynx
brew install p7zip
brew install pigz
brew install pv
brew install rename
brew install rlwrap
brew install ssh-copy-id
brew install tree
brew install vbindiff
brew install zopfli
brew install htop

# Remove outdated versions from the cellar.
brew cleanup

# Fonts
cd; mkdir code; cd code; git clone https://github.com/powerline/fonts.git; cd fonts; ./install.sh; cd
