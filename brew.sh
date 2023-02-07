#!/usr/bin/env bash

osname=$(uname)

if [ "$osname" != "Darwin" ]; then
  bootstrap_echo "Oops, it looks like you're using a non-UNIX system. This script
only supports Mac. Exiting..."
  exit 1
fi

################################################################################
# Authenticate
################################################################################

sudo -v

# Keep-alive: update existing `sudo` time stamp until bootstrap has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Install command-line tools using Homebrew.
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Updates
sudo softwareupdate -i -a
xcode-select --install

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils

# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed
# Install Bash 4.
# Note: don’t forget to add `/usr/local/bin/bash` to `/etc/shells` before
# running `chsh`.
curl -L git.io/antigen > antigen.zsh
brew install bash
brew install bash-completion2
brew install zsh zsh-completions
brew install zsh-syntax-highlighting
cd ~ && git clone https://github.com/zsh-users/antigen.git .antigen
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Editors
brew install --cask visual-studio-code
code --install-extension eamodio.gitlens

# Utilities
brew install --cask multipass
brew install the_silver_searcher
brew install --cask spectacle
brew install tmux
gem install tmuxinator
gem install teamocil
brew install mr
brew install --cask sublime-text
brew install --cask atom
brew install --cask pycharm
brew install --cask virtualbox
brew install docker
brew install --cask docker
brew install --cask spotify
brew install --cask caffeine
brew install --cask tunnelblick
brew install --cask the-unarchiver
brew install htop
brew install --cask istat-menus
brew install --cask google-chrome
brew install --cask iterm2
brew install --cask lastpass
brew install --cask little-snitch
brew install --cask gpg-suite

# App Store
brew install mas 

# Bear Notes & Evernote
mas install 1091189122
mas install 406056744

# MacOS settings
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder AppleShowAllFiles YES
defaults write com.apple.LaunchServices LSQuarantine -bool false
defaults write com.apple.CrashReporter DialogType -string "none"
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName
sudo systemsetup -setrestartfreeze on
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"
defaults write com.apple.finder WarnOnEmptyTrash -bool false

###############################################################################
# Dock, Dashboard, and hot corners                                            #
###############################################################################

# Position dock on the left side of the screen
defaults write com.apple.dock orientation -string "left"

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Enable highlight hover effect for the grid view of a stack (Dock)
defaults write com.apple.dock mouse-over-hilite-stack -bool true

# Set the icon size of Dock items to 72 pixels
defaults write com.apple.dock tilesize -int 72

# Enable spring loading for all Dock items
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true

# Speed up Mission Control animations
defaults write com.apple.dock expose-animation-duration -float 0.1

# Disable Dashboard
defaults write com.apple.dashboard mcx-disabled -bool true

# Don’t show Dashboard as a Space
defaults write com.apple.dock dashboard-in-overlay -bool true

# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Remove the auto-hiding Dock delay
defaults write com.apple.dock autohide-delay -float 0

# Make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true

# Hot corners
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
# Bottom left screen corner → Display sleep
defaults write com.apple.dock wvous-bl-corner -int 10
defaults write com.apple.dock wvous-bl-modifier -int 0


# Switch to using brew-installed bash as default shell
if ! fgrep -q '/usr/local/bin/zsh' /etc/shells; then
  echo '/usr/local/bin/zsh' | sudo tee -a /etc/shells;
  chsh -s /usr/local/bin/zsh;
fi;

brew install wget

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

# Install fonts.
if [ ! -d "$CODE" ]; then
  mkdir "$CODE"
fi

if [ ! -d "$CODE"/fira-code ]; then
  git clone https://github.com/tonsky/FiraCode "$CODE"/fira-code
  cp "$CODE"/fira-code/distr/ttf/* "$HOME"/Library/Fonts/
fi

if [ ! -d "$CODE"/fonts ]; then
  git clone https://github.com/powerline/fonts.git "$CODE"/fonts
  pushd "$CODE"/fonts
  ./install.sh
  popd
fi

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

# Misc Work
brew install --cask docker
brew install terraform
brew install warrensbox/tap/tfswitch
brew install awscli
brew tap wallix/awless; brew install awless
brew install kops
brew install kubernetes-cli
brew install --cask minikube
brew install fzf
brew install node
npm install --global fast-cli
brew install pass-otp

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
brew install --cask spectacle
brew install tmux
gem install tmuxinator
brew install reattach-to-user-namespace
brew install mr
brew install --cask sublime-text
brew install --cask spotify
#brew install --cask caffeine
#brew install --cask tunnelblick
brew install --cask the-unarchiver
brew install htop
brew install --cask istat-menus
brew install --cask iterm2
brew install telnet

# Code

# Python
brew install python
brew install python3
sudo easy_install pip
sudo pip install --upgrade pip
pip3 install --upgrade pip setuptools wheel
pip3 install virtualenv virtualenvwrapper
code --install-extension ms-python.python

# Ruby
curl -L https://get.rvm.io | bash -s stable --rails --autolibs=enabled
brew install rbenv
rbenv install 2.6.3
rbenv global 2.6.3
gem install bundler

# Go
brew install go
go get golang.org/x/tools/cmd/godoc
go get github.com/golang/lint/golint
code --install-extension ms-vscode.Go

# Kubernetes
brew tap jenkins-x/jx 
brew install jx 

# Databases
brew install mysql
brew install postgres

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

# Install other useful binaries.
brew install qrencode
brew install ack
brew install git
brew install git-lfs
brew install jq
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
brew install csshx
brew install --cask java

# Remove outdated versions from the cellar.
brew cleanup

# Fonts
cd; mkdir code; cd code; git clone https://github.com/powerline/fonts.git; cd fonts; ./install.sh; cd

xcode-select --install

# Install some CTF tools; see https://github.com/ctfs/write-ups.
brew install nmap
brew install telnet
#brew install aircrack-ng
#brew install bfg
#brew install binutils
#brew install binwalk
#brew install cifer
#brew install dex2jar
#brew install dns2tcp
#brew install fcrackzip
#brew install foremost
#brew install hashpump
#brew install hydra
#brew install john
#brew install knock
#brew install netpbm
#brew install pngcheck
#brew install socat
#brew install sqlmap
#brew install tcpflow
#brew install tcpreplay
#brew install tcptrace
#brew install ucspi-tcp # `tcpserver` etc.
#brew install xpdf
#brew install xz

# Remove outdated versions from the cellar.
brew cleanup
