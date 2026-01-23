# My .zshrc file
#
# Some functions taken from various web sites/mailing lists, others written
# myself.
#
# Last updated Sept 2023

# If Cursor launches under Rosetta, re-exec as arm64.
if [[ "$(uname -m)" == "x86_64" ]] && [[ -z "${ZSH_ARCH_FIXED:-}" ]]; then
  if [[ "$(sysctl -n sysctl.proc_translated 2>/dev/null)" == "1" ]]; then
    export ZSH_ARCH_FIXED=1
    exec /usr/bin/arch -arm64 /bin/zsh -l
  fi
fi

git config --global user.email "ablackwell@2u.com"
git config --global user.name "Adam Blackwell"

export ZSH=$HOME/.oh-my-zsh
export CODE=$HOME/code
source ~/.profile
autoload -Uz compinit && compinit
autoload bashcompinit && bashcompinit

# AWS
export ONELOGIN_EMAIL="ablackwell@2u.com"
export UPDATE_PS1_ASSUME_ROLE=false

ad-get-users-groups ()
{
 local user=${1:?"No Username Provided/"};
 dscl '/Active Directory/2TOR/All Domains' read "/Users/${user}" dsAttrTypeNative:memberOf | ( read -r;
 printf "%s\n" "$REPLY";
 sort -f )
}

ad-get-group-members ()
{
 local group=${1:?"No Group Provided/"};
 dscl '/Active Directory/2TOR/All Domains' read "/Groups/${group}" GroupMembership | ( read -r;
 printf "%s\n" "$REPLY";
 sort -f )
}

ulimit -n 4096

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="agnoster"

#plugins=(git)

alias cal=gcal
alias bfg="java -jar $HOME/bin/bfg.jar"

# Python
#export VIRTUALENVWRAPPER_PYTHON=/usr/local/opt/python/libexec/bin/python

# Ruby
#eval "$(rbenv init -)"

# Kubernetes
#[ -f $HOME/bin/fubectl.source ] && source $HOME/bin/fubectl.source

# Shell

#source $ZSH/oh-my-zsh.sh
#source $ZSH/tmuxinator.zsh

# Aliases
# alias ag='allgit'
alias cfs="aws cloudformation describe-stacks --query 'Stacks[].StackName'"
alias asgs="aws autoscaling describe-auto-scaling-groups --query 'AutoScalingGroups[].AutoScalingGroupName'"
alias elbs="aws elb describe-load-balancers --query 'LoadBalancerDescriptions[].LoadBalancerName'"
alias deploys="aws ec2 describe-tags --filter \"Name=tag-key,Values=Deployment\" --query 'Tags[].Value' | grep '\"' | sed 's/.*\"\(.*"

# antigen
#source ~/.antigen/antigen.zsh

# Load the oh-my-zsh's library.
#antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
#antigen bundle git
#antigen bundle python
#antigen bundle history
#antigen bundle command-not-found

# Syntax highlighting bundle.
#antigen bundle zsh-users/zsh-completions src
#antigen bundle zsh-users/zsh-syntax-highlighting
#antigen theme arialdomartini/oh-my-git-themes oppa-lana-style


# OSX Specific
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

function print-lines(){
    trap 'echo "# $BASH_COMMAND"' DEBUG
}

function venv-clear()
{
  (
   print-lines;
   local previous=`basename $VIRTUAL_ENV`
   deactivate;
   rmvirtualenv $previous;
   mkvirtualenv $previous "$@";
   workon $previous;
  )
}

syspip(){
   PIP_REQUIRE_VIRTUALENV="" pip "$@"
}

#Mail
textme(){
   echo "$@" | sendmail 2072458048@vtext.com
}

alias c='cd ~/code'

# rc
alias rc='vi ~/.zshrc'

# Skip all this for non-interactive shells
[[ -z "$PS1" ]] && return

# AWS (interactive shells only)
source $CODE/edx/edx-internal/scripts/assume-role-onelogin.sh
alias assume=assume_role

# Set prompt (white and purple, nothing too fancy)
PS1=$'%{\e[0;37m%}%B%*%b %{\e[0;35m%}%m:%{\e[0;37m%}%~ %(!.#.>) %{\e[00m%}'
XDG_CONFIG_DIRS=$HOME/.config

# Set less options
if [[ -x $(which less) ]]
then
    export PAGER="less"
    export LESS="--ignore-case --LONG-PROMPT --QUIET --chop-long-lines -Sm --RAW-CONTROL-CHARS --quit-if-one-screen --no-init"
    if [[ -x $(which lesspipe.sh) ]]
    then
  LESSOPEN="| lesspipe.sh %s"
  export LESSOPEN
    fi
fi

# Set default editor
if [[ -x $(which vim) ]]
then
    export EDITOR="vim"
    export USE_EDITOR=$EDITOR
    export VISUAL=$EDITOR
fi

# Zsh settings for history
export HISTIGNORE="&:ls:[bf]g:exit:reset:clear:cd:cd ..:cd.."
export HISTSIZE=99000
export HISTTIMEFORMAT="%d/%m/%y %T "
export HISTFILE=~/.zsh_history
export SAVEHIST=99000
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward
bindkey \^U backward-kill-line
bindkey -e
bindkey '[C' forward-word
bindkey '[D' backward-word


# Zsh spelling correction options
setopt CORRECT
#setopt DVORAK

# Prompts for confirmation after 'rm *' etc
# Helps avoid mistakes like 'rm * o' when 'rm *.o' was intended
setopt RM_STAR_WAIT

# Background processes aren't killed on exit of shell
setopt AUTO_CONTINUE

# Don’t write over existing files with >, use >! instead
setopt NOCLOBBER

# Don’t nice background processes
setopt NO_BG_NICE

# Watch other user login/out
watch=notme
export LOGCHECK=60

# Enable color support of ls
if [[ "$TERM" != "dumb" ]]; then
    if [[ -x `which dircolors` ]]; then
  eval `dircolors -b`
  alias 'ls=ls --color=auto'
    fi
fi

# Short command aliases
alias 'l=ls'
alias 'la=ls -Ahl | less'
alias 'll=ls -l'
alias 'lq=ls -Q'
alias 'lr=ls -R'
alias 'lrs=ls -lrS'
alias 'lrt=ls -lrt'
alias 'lrta=ls -lrtA'
alias 'j=jobs -l'
alias 'kw=kwrite'
alias 'tf=tail -f'
alias 'grep=grep --colour'
alias 'e=emacs -nw --quick'
alias 'vi=vim'
alias 'sx=screen -x'
alias 'sr=screen -rD'
alias 'sl=screen -ls'

# Temporary custom aliases
alias 'ps=ps -dcl L'
alias 'vnc=ssh -f -L 9999:localhost:5901 ada2358@pacman.ccs.neu.edu \ vncviewer -encodings tight localhost::9999 -passwd ~/.vnc/passwd'
alias 'vncs=vncserver -nolisten tcp -localhost -nevershared -geometry 1278x945'

# Useful KDE integration (see later for definition of z)
alias 'q=z kfmclient openURL' # Opens (or executes a .desktop) arg1 in Konqueror

# These are useful with the Dvorak keyboard layout
alias 'h=ls'
alias 'ha=la'
alias 'hh=ll'
alias 'hq=lq'
alias 'hr=lr'
alias 'hrt=lrt'
alias 'hrs=lrs'

# Play safe!
alias 'rm=rm -i'
alias 'mv=mv -i'
alias 'cp=cp -i'

# For convenience
alias 'mkdir=mkdir -p'
alias 'dus=du -H -msh * | sort -n'
alias "cmds=history | awk '{a[$2]++}END{for(i in a){print a[i] " " i}}' | sort -rn | head"
alias 'ports=netstat -tlnp'
alias "tof=watch --differences -n 5 'df; ls -FlAt;'"
alias 'myip=python -c "import socket; print '\n'.join(socket.gethostbyname_ex(socket.gethostname())[2])"'
alias 'dis=~/bin/distribute.sh'
alias 'tot=~/bin/total_summary'
alias 'lm=linuxmachines'
alias 'tu=top -u'
alias 'ta=top -u ada2358'
alias 'chweb=chmod -R 755 ~/.www'
alias 'chcourse=chmod -R 755 ~/classes/*/*'

# Shortcuts
alias 'hm=cd ~'

# Typing errors...
alias 'cd..=cd ..'

# AWS
awsenv ()
{
  environment=$1;
  if [[ -z $environment ]]; then
  	env | grep --color=auto AWS;
  else
  	if [[ $environment == 'clear' ]]; then
  		unset AWS_PROFILE;
  		unset AWS_DEFAULT_PROFILE;
  	else
  		export AWS_PROFILE=$environment;
  		export AWS_DEFAULT_PROFILE=$environment;
  		env | grep --color=auto AWS;
    fi;
  fi
}

# Running 'b.ps' runs 'q b.ps'
alias -s ps=q
alias -s html=q

# PDF viewer (just type 'file.pdf')
if [[ -x `which kpdf` ]]; then
    alias -s 'pdf=kfmclient exec'
else
    if [[ -x `which gpdf` ]]; then
  alias -s 'pdf=gpdf'
    else
  if [[ -x `which evince` ]]; then
  		alias -s 'pdf=evince'
  fi
    fi
fi

# Global aliases (expand whatever their position)
#  e.g. find . E L
alias -g L='| less'
alias -g H='| head'
alias -g S='| sort'
alias -g T='| tail'
alias -g N='> /dev/null'
alias -g E='2> /dev/null'

# Automatically background processes (no output to terminal etc)
alias 'z=echo $RANDOM > /dev/null; zz'
zz () {
    echo $*
    $* &> "/tmp/z-$1-$RANDOM" &!
}

# Aliases to use this
# Use e.g. 'command gv' to avoid
alias 'acroread=z acroread'
alias 'amarok=z amarok'
alias 'azureus=z azureus'
alias 'easytag=z easytag'
alias 'eclipse=z eclipse'
alias 'firefox=z firefox'
alias 'icedove=z icedove'
alias 'gaim=z gaim'
alias 'gimp=z gimp'
alias 'gpdf=z gpdf'
alias 'gv=z gv'
alias 'k3b=z k3b'
alias 'kate=z kate'
alias 'kmail=z kmail'
alias 'konqueror=z konqueror'
alias 'konsole=z konsole'
alias 'kontact=z kontact'
alias 'kopete=z kopete'
alias 'kpdf=z kpdf'
alias 'kwrite=z kwrite'
alias 'ooffice=z ooffice'
alias 'oowriter=z oowriter'
alias 'opera=z opera'
alias 'pan=z pan'
alias 'sunbird=z sunbird'
alias 'thunderbird=z thunderbird'

# Quick find
f() {
    echo "find . -iname \"*$1*\""
    find . -iname "*$1*"
}

# Remap Dvorak-Qwerty quickly
alias 'aoeu=setxkbmap gb' # (British keyboard layout)
#alias 'asdf=setxkbmap gb dvorak 2> /dev/null || setxkbmap dvorak gb 2> /dev/null || setxkbmap dvorak'

# Clear konsole history
alias 'zaph=dcop $KONSOLE_DCOP_SESSION clearHistory'

# When directory is changed set xterm title to host:dir
chpwd() {
    [[ -t 1 ]] || return
    case $TERM in
  sun-cmd) print -Pn "\e]l%~\e\\";;
        *xterm*|rxvt|(dt|k|E)term) print -Pn "\e]2;%m:%~\a";;
    esac
}

# For quickly plotting data with gnuplot.  Arguments are files for 'plot "<file>" with lines'.
plot () {
    echo -n '(echo set term png; '
    echo -n 'echo -n plot \"'$1'\" with lines; '
    for i in $*[2,$#@]; echo -n 'echo -n , \"'$i'\" with lines; '
    echo 'echo ) | gnuplot | display png:-'

    (
  echo "set term png"
  echo -n plot \"$1\" with lines
  for i in $*[2,$#@]; echo -n "," \"$i\" "with lines"
  ) | gnuplot | display png:-
}

# Persistant gnuplot (can be resized etc)
plotp () {
    echo -n '(echo -n plot \"'$1'\" with lines; '
    for i in $*[2,$#@]; echo -n 'echo -n , \"'$i'\" with lines; '
    echo 'echo ) | gnuplot -persist'

    (
  echo -n plot \"$1\" with lines
  for i in $*[2,$#@]; echo -n "," \"$i\" "with lines"
  echo
  ) | gnuplot -persist
}

# CD into random directory in PWD
cdrand () {
  all=( *(/) )
  rand=$(( 1 + $RANDOM % $#all ))
  cd $all[$rand]
}

# Print some stuff
if [[ -x `which date` ]]; then
    date
    echo
fi
if [[ -x `which fortune` ]]; then
    fortune -a 2> /dev/null
fi

# The following lines were added by compinstall
zstyle ':completion:*' completer _expand _complete _match
zstyle ':completion:*' completions 0
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' glob 0
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list '+m:{a-z}={A-Z} r:|[._-]=** r:|=**' '' '' '+m:{a-z}={A-Z} r:|[._-]=** r:|=**'
zstyle ':completion:*' max-errors 1 numeric
zstyle ':completion:*' substitute 0
zstyle :compinstall filename "$HOME/.zshrc"

autoload -Uz compinit
compinit
# End of lines added by compinstall

zstyle -d users
zstyle ':completion:*:*:*:users' ignored-patterns \
    adm apache bin daemon games gdm halt ident junkbust lp mail mailnull \
    named news nfsnobody nobody nscd ntp operator pcap postgres radvd \
    rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs backup  bind  \
    dictd  gnats  identd  irc  man  messagebus  postfix  proxy  sys  www-data \
    avahi Debian-exim hplip list cupsys haldaemon ntpd proftpd statd

zstyle ':completion:*:cd:*' ignored-patterns '(*/)#lost+found'

zstyle ':completion:*:(rm|kill|diff):*' ignore-line yes
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

# Filename suffixes to ignore during completion (except after rm command)
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.c~' \
    '*?.old' '*?.pro'

zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/)CVS'
zstyle ':completion:*:cd:*' ignored-patterns '(*/)#CVS'

zstyle ':completion:*:*:xdvi:*' file-sort time

autoload zsh/sched

# Copys word from earlier in the current command line
# or previous line if it was chosen with ^[. etc
autoload copy-earlier-word
zle -N copy-earlier-word
bindkey '^[,' copy-earlier-word

# Cycle between positions for ambigous completions
autoload cycle-completion-positions
zle -N cycle-completion-positions
bindkey '^[z' cycle-completion-positions

# Increment integer argument
autoload incarg
zle -N incarg
bindkey '^X+' incarg

# Write globbed files into command line
autoload insert-files
zle -N insert-files
bindkey '^Xf' insert-files

# Play tetris
autoload -U tetris
zle -N tetris
bindkey '^X^T' tetris

# xargs but zargs
autoload -U zargs

# Calculator
autoload zcalc

# Line editor
autoload zed

# Renaming with globbing
autoload zmv

# Various reminders of things I forget...
# (Mostly useful features that I forget to use)
# vared
# =ls turns to /bin/ls
# =(ls) turns to filename (which contains output of ls)
# <(ls) turns to named pipe
# ^X* expand word
# ^[^_ copy prev word
# ^[A accept and hold
# echo $name:r not-extension
# echo $name:e extension
# echo $xx:l lowercase
# echo $name:s/foo/bar/

# Add RVM and Pyenv to PATH for scripting. Make sure this is the last PATH variable change.
#export PATH="/usr/local/sbin:$PATH:$HOME/.rvm/bin"

# PATH Stuff
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/bin:/usr/bin:/sbin:/usr/sbin:$PATH"
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
if [[ -d /opt/homebrew ]]; then
  export HOMEBREW_PREFIX="/opt/homebrew"
elif [[ -d /usr/local ]]; then
  export HOMEBREW_PREFIX="/usr/local"
fi
if [[ -n "${HOMEBREW_PREFIX:-}" ]]; then
  export PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH"
fi
if [[ -n "${HOMEBREW_PREFIX:-}" ]]; then
  export PATH="$HOME/bin:$HOMEBREW_PREFIX/opt/python/libexec/bin:$PATH:$GOPATH:$GOBIN"
else
  export PATH="$HOME/bin:$PATH:$GOPATH:$GOBIN"
fi
export PATH="$PATH:$CODE/tools/allgit"
export PATH="$PATH:$HOME/Library/Python/3.11/bin"

# Prefer arm64 toolchain on Apple Silicon
if [[ "$(uname -m)" == "arm64" ]]; then
  path=(${path:#/usr/local/bin} ${path:#/usr/local/sbin} ${path:#/usr/local/opt/python/libexec/bin})
fi
rehash 2>/dev/null || true

# Pyenv (interactive shells only)
if command -v pyenv >/dev/null 2>&1; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
fi

#antigen apply
if [[ -n "${HOMEBREW_PREFIX:-}" ]] && [[ -r "${HOMEBREW_PREFIX}/opt/asdf/libexec/asdf.sh" ]]; then
  . "${HOMEBREW_PREFIX}/opt/asdf/libexec/asdf.sh"
fi

export NVM_DIR="$HOME/.nvm"
if [[ "$(uname -m)" != "arm64" ]] || [[ "${USE_NVM:-}" == "1" ]]; then
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

# Added by Antigravity
export PATH="/Users/adam/.antigravity/antigravity/bin:$PATH"

# bun completions
[ -s "/Users/adam/.bun/_bun" ] && source "/Users/adam/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Node
if command -v fnm >/dev/null 2>&1; then
  eval "$(fnm env --use-on-cd)"
fi