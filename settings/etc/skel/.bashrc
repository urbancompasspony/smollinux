# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

#-----------------------------------------------
# Configurações Gerais
#-----------------------------------------------

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Não armazenar as linhas duplicadas ou linhas que começam com espaço no historico
HISTCONTROL=ignoreboth

# Adicionar ao Historico e não substitui-lo
shopt -s histappend

# Definições do comprimento e tamnho do historico.
HISTSIZE=1000
HISTFILESIZE=2000

#===========================================
# Váriavies com as Cores
#===========================================
NONE="\[\033[0m\]" # Eliminar as Cores (deixar padrão)

## Cores de Fonte
K="\[\033[0;30m\]" # Black (Preto)
R="\[\033[0;31m\]" # Red (Vermelho)
G="\[\033[0;32m\]" # Green (Verde)
Y="\[\033[0;33m\]" # Yellow (Amarelo)
B="\[\033[0;34m\]" # Blue (Azul)
M="\[\033[0;35m\]" # Magenta (Vermelho Claro)
C="\[\033[0;36m\]" # Cyan (Ciano - Azul Claro)
W="\[\033[0;37m\]" # White (Branco)

## Efeito Negrito (bold) e cores
BK="\[\033[1;30m\]" # Bold+Black (Negrito+Preto)
BR="\[\033[1;31m\]" # Bold+Red (Negrito+Vermelho)
BG="\[\033[1;32m\]" # Bold+Green (Negrito+Verde)
BY="\[\033[1;33m\]" # Bold+Yellow (Negrito+Amarelo)
BB="\[\033[1;34m\]" # Bold+Blue (Negrito+Azul)
BM="\[\033[1;35m\]" # Bold+Magenta (Negrito+Vermelho Claro)
BC="\[\033[1;36m\]" # Bold+Cyan (Negrito+Ciano - Azul Claro)
BW="\[\033[1;37m\]" # Bold+White (Negrito+Branco)

## Cores de fundo (backgroud)
BGK="\[\033[40m\]" # Black (Preto)
BGR="\[\033[41m\]" # Red (Vermelho)
BGG="\[\033[42m\]" # Green (Verde)
BGY="\[\033[43m\]" # Yellow (Amarelo)
BGB="\[\033[44m\]" # Blue (Azul)
BGM="\[\033[45m\]" # Magenta (Vermelho Claro)
BGC="\[\033[46m\]" # Cyan (Ciano - Azul Claro)
BGW="\[\033[47m\]" # White (Branco)

#=============================================
# Configurações referentes ao usuário
#=============================================

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# Descomente para Terminal Colorido; Definido em desligado por padrão 
# para não distrair o usuário; O foco é na janela de terminal, não no prompt.
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then

#PS1="$BG┌─[$BC\u$BG]$BR@$BG[$BB\h$BG]:$BG[$BY\w$BG] \n└──╼ $ $NONE"

PS1="$BK┌─$BK[$BR\u$BK]$BR@$BK[$BR\h$BK]$BR:$BK[$BR\w$BK] $BK \n└──╼ $BR$ $NONE"

#BK="\[\033[1;30m\]" # Bold+Black (Negrito+Preto)
#BR="\[\033[1;31m\]" # Bold+Red (Negrito+Vermelho)
#BG="\[\033[1;32m\]" # Bold+Green (Negrito+Verde)
#BY="\[\033[1;33m\]" # Bold+Yellow (Negrito+Amarelo)
#BB="\[\033[1;34m\]" # Bold+Blue (Negrito+Azul)
#BM="\[\033[1;35m\]" # Bold+Magenta (Negrito+Vermelho Claro)
#BC="\[\033[1;36m\]" # Bold+Cyan (Negrito+Ciano - Azul Claro)
#BW="\[\033[1;37m\]" # Bold+White (Negrito+Branco)

#PS1="$BR┌─[$BG\u$BR]$BY@$BR[$BW${HOSTNAME%%.*}$BR]$B:\w\n$BR└──>$BG Ω $NONE"

#PS1="\e[01;31m┌─[\e[01;35m\u\e[01;31m]──[\e[00;37m${HOSTNAME%%.*}\e[01;32m]:\w$\e[01;31m\n\e[01;31m└──\e[01;36m>>\e[00m"

#PS1='[\u@\h \W]\$ '

else
	PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
	
fi

# BKP PS1="┌─[\[\e[34m\]\u\[\e[0m\]][\[\e[34m\]\h\[\e[0m\]][\[\e[34m\]\w\[\e[0m\]]\n└─╼ "

# COR: \[\e[34m\]

#PS1="$G┌─[$BR\u$G]$BY@$G[$BW${HOSTNAME%%.*}$G]$B:\w\n$G└──>$BR \\$ $NONE"

unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias sf='screenfetch'
#alias rm='rm -i'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# AutoLiveMENU
timedatectl set-timezone America/Bahia

# Default password to "ubuntu"
echo -ne "$USER\n$USER\n" | sudo passwd $USER 1> /dev/null 2> /dev/null
# Default samba share password to "ubuntu"
echo -ne "$USER\n$USER\n" | sudo smbpasswd -a $USER 1> /dev/null 2> /dev/null

[ -f /$USER/.live ] && { /$USER/.live; }
alias menu='/$USER/.live'
alias srv='curl -sSL https://srv.linuxuniverse.com.br | bash'

#alias singlenmap="echo 'sudo nmap -Pn --script vuln --exclude 9100 -p1-9099,9101-65535 IP'"
alias singlenmap="sudo nmap -Pn --script vuln --exclude 9100 -p1-9099,9101-65535"

# Check my IP over LAN and WAN
alias iplan="hostname -I | awk '{print $1}'"
alias ipwan="dig @resolver4.opendns.com myip.opendns.com +short"
