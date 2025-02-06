# for debug start with
# ! time ZSH_DEBUGRC=1 zsh -i -c 'zprof; exit' | less
if [[ -n $ZSH_DEBUGRC ]]; then
    zmodload zsh/zprof
fi
# Personal Zsh configuration file. It is strongly recommended to keep all
# shell customization and configuration (including exported environment
# variables such as PATH) in this file or in files sourced from it.
#
# Documentation: https://github.com/romkatv/zsh4humans/blob/v5/README.md.

# Periodic auto-update on Zsh startup: 'ask' or 'no'.
# You can manually run `z4h update` to update everything.
zstyle ':z4h:' auto-update      'no'
# Ask whether to auto-update this often; has no effect if auto-update is 'no'.
zstyle ':z4h:' auto-update-days '28'

# Keyboard type: 'mac' or 'pc'.
zstyle ':z4h:bindkey' keyboard  'pc'

# Don't start tmux.
zstyle ':z4h:' start-tmux       yes

# Mark up shell's output with semantic information.
zstyle ':z4h:' term-shell-integration 'yes'

# Right-arrow key accepts one character ('partial-accept') from
# command autosuggestions or the whole thing ('accept')?
zstyle ':z4h:autosuggestions' forward-char 'accept'

# Recursively traverse directories when TAB-completing files.
zstyle ':z4h:fzf-complete' recurse-dirs 'no'

# Enable direnv to automatically source .envrc files.
zstyle ':z4h:direnv'         enable 'no'
# Show "loading" and "unloading" notifications from direnv.
zstyle ':z4h:direnv:success' notify 'yes'

# Enable ('yes') or disable ('no') automatic teleportation of z4h over
# SSH when connecting to these hosts.
zstyle ':z4h:ssh:example-hostname1'   enable 'yes'
zstyle ':z4h:ssh:*.example-hostname2' enable 'no'
# The default value if none of the overrides above match the hostname.
zstyle ':z4h:ssh:*'                   enable 'yes'

# Send these files over to the remote host when connecting over SSH to the
# enabled hosts.
zstyle ':z4h:ssh:*' send-extra-files '~/.nanorc' '~/.env.zsh'

# Start ssh-agent if it's not running yet.
zstyle ':z4h:ssh-agent:' start yes

# Clone additional Git repositories from GitHub.
#
# This doesn't do anything apart from cloning the repository and keeping it
# up-to-date. Cloned files can be used after `z4h init`. This is just an
# example. If you don't plan to use Oh My Zsh, delete this line.
mkdir -p ~/.zshrc.d
z4h install mattmc3/zshrc.d || return

# Install or update core components (fzf, zsh-autosuggestions, etc.) and
# initialize Zsh. After this point console I/O is unavailable until Zsh
# is fully initialized. Everything that requires user interaction or can
# perform network I/O must be done above. Everything else is best done below.
z4h init || return

# Extend PATH
path=(~/bin $path)

# Export environment variables.
export GPG_TTY=$TTY

# Source additional local files if they exist.
z4h source ~/.env.zsh

# Use additional Git repositories pulled in with `z4h install`.
#
# This is just an example that you should delete. It does nothing useful.
# z4h source ohmyzsh/ohmyzsh/lib/diagnostics.zsh  # source an individual file
# z4h load   ohmyzsh/ohmyzsh/plugins/emoji-clock  # load a plugin
z4h load   mattmc3/zshrc.d  # load a plugin

# Define key bindings.
z4h bindkey z4h-backward-kill-word  Ctrl+Backspace     Ctrl+H
z4h bindkey z4h-backward-kill-zword Ctrl+Alt+Backspace

z4h bindkey undo Ctrl+/ Shift+Tab  # undo the last command line change
z4h bindkey redo Alt+/             # redo the last undone command line change

z4h bindkey z4h-cd-back    Alt+Left   # cd into the previous directory
z4h bindkey z4h-cd-forward Alt+Right  # cd into the next directory
z4h bindkey z4h-cd-up      Alt+Up     # cd into the parent directory
z4h bindkey z4h-cd-down    Alt+Down   # cd into a child directory

# Autoload functions.
autoload -Uz zmv

# Define functions and completions.
function md() { [[ $# == 1 ]] && mkdir -p -- "$1" && cd -- "$1" }
compdef _directories md

# Define named directories: ~w <=> Windows home directory on WSL.
[[ -z $z4h_win_home ]] || hash -d w=$z4h_win_home

# Define aliases.
alias tree='tree -a -I .git'

# Add flags to existing aliases.
alias ls="${aliases[ls]:-ls} -A"

# Set shell options: http://zsh.sourceforge.net/Doc/Release/Options.html.
setopt glob_dots     # no special treatment for file names with a leading dot
setopt no_auto_menu  # require an extra TAB press to open the completion menu


[[ -f ${HOME}/.profile ]] && source "${HOME}/.profile"

export WORDCHARS='~!#$%^&*(){}[]<>?+;'

# # fix iterm2 macos bindings https://stackoverflow.com/a/29403520
if [[ "$(uname -s)" == "Darwin" ]]; then # macos
    bindkey -e
    # changes hex 0x15 to delete everything to the left of the cursor,
    # rather than the whole line
    bindkey "^U" backward-kill-line

    # binds hex 0x18 0x7f with deleting everything to the left of the cursor
    bindkey "^X\\x7f" backward-kill-line

    # adds redo
    bindkey "^X^_" redo
    [[ -d /opt/homebrew/share/zsh/site-functions ]] && fpath+=/opt/homebrew/share/zsh/site-functions(N)
    export HOMEBREW_NO_AUTO_UPDATE=1
else # linux
    bindkey -e
    typeset -g -A key

    # use kitty to find out keycodes
    key[Insert]="^[[2~"
    key[PageUp]="^[[5~"
    key[PageDown]="^[[6~"
    key[Shift-Tab]="^[[Z"
    key[Alt-Left]="^A"
    key[Alt-Right]="^E"

    my-forward-delete-word () {
        # do not stop deleting for these chars (in addition to normal chars)
        local WORDCHARS='~!#$%^&*(){}[]<>?+;'
        zle kill-word
    }
    zle -N my-forward-delete-word

    my-backward-delete-word () {
        # do not stop deleting for these chars (in addition to normal chars)
        local WORDCHARS='~!#$%^&*(){}[]<>?+;'
        zle backward-kill-word
    }
    zle -N my-backward-delete-word

    key[Home]="^[[H"
    key[End]="^[[F"

    key[Up]="^[[A"
    key[Down]="^[[B"
    key[Left]="^[[D"
    key[Right]="^[[C"

    key[Backspace]="^?"
    key[Delete]="^[[3~"

    key[Ctrl-Left]="^[[1;5D"
    key[Ctrl-Right]="^[[1;5C"

    key[Ctrl-Backspace]="^H"
    key[Ctrl-Del]="^[[3;5~"

    # key[Alt-Backspace]="^?"
    # key[Alt-Del]="^[[3~"

    # # setup key accordingly
    [[ -n "${key[Home]}"            ]] && bindkey -- "${key[Home]}"             beginning-of-line
    [[ -n "${key[End]}"             ]] && bindkey -- "${key[End]}"              end-of-line
    # [[ -n "${key[Insert]}"          ]] && bindkey -- "${key[Insert]}"           overwrite-mode
    [[ -n "${key[Backspace]}"       ]] && bindkey -- "${key[Backspace]}"        backward-delete-char
    [[ -n "${key[Delete]}"          ]] && bindkey -- "${key[Delete]}"           delete-char
    [[ -n "${key[Up]}"              ]] && bindkey -- "${key[Up]}"               up-line-or-history
    [[ -n "${key[Down]}"            ]] && bindkey -- "${key[Down]}"             down-line-or-history
    [[ -n "${key[Left]}"            ]] && bindkey -- "${key[Left]}"             backward-char
    [[ -n "${key[Right]}"           ]] && bindkey -- "${key[Right]}"            forward-char
    # [[ -n "${key[PageUp]}"          ]] && bindkey -- "${key[PageUp]}"           beginning-of-buffer-or-history
    # [[ -n "${key[PageDown]}"        ]] && bindkey -- "${key[PageDown]}"         end-of-buffer-or-history
    # [[ -n "${key[Shift-Tab]}"       ]] && bindkey -- "${key[Shift-Tab]}"        reverse-menu-complete
    [[ -n "${key[Ctrl-Left]}"       ]] && bindkey -- "${key[Ctrl-Left]}"        backward-word
    [[ -n "${key[Ctrl-Right]}"      ]] && bindkey -- "${key[Ctrl-Right]}"       forward-word
    [[ -n "${key[Ctrl-Backspace]}"  ]] && bindkey -- "${key[Ctrl-Backspace]}"   backward-kill-word
    [[ -n "${key[Ctrl-Del]}"        ]] && bindkey -- "${key[Ctrl-Del]}"         kill-word
    # [[ -n "${key[Alt-Left]}"        ]] && bindkey -- "${key[Alt-Left]}"         backward-word
    # [[ -n "${key[Alt-Right]}"       ]] && bindkey -- "${key[Alt-Right]}"        forward-word
    # [[ -n "${key[Alt-Backspace]}"   ]] && bindkey -- "${key[Alt-Backspace]}"    backward-kill-word
    # [[ -n "${key[Alt-Del]}"         ]] && bindkey -- "${key[Alt-Del]}"          kill-word

fi

[[ -x $(command -v brew) ]] && FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"


# also:  kompose kubectl helm docker helmfile kustomize caddy k3d
# for cmd in k3d; do
#     if [[ -x $(command -v $cmd) ]]; then
#         source <($cmd completion zsh)
#     fi
# done


export ___X_CMD_ADVISE_DISABLE=1
x(){
    if [[ -f "$HOME/.x-cmd.root/X" ]]; then
        unfunction "$0"
        . "$HOME/.x-cmd.root/X"
        $0 "$@"
    fi
}

export VISUAL=vim
export EDITOR="$VISUAL"

#####
# paths
path_dirs=(
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
)
for dir in $path_dirs; do
    [[ -d $dir ]] && PATH="$dir:$PATH"
done

[[ -f $HOME/.cargo/env ]] && source "$HOME/.cargo/env"



#####
# aliases

# eza
alias l='ls -lah'
alias ll='ls -lh'
if [[ -x $(command -v eza) ]]; then
    alias tree='eza -T --git-ignore'
    alias l='eza -ahg'
    alias ll='eza -lahg'
else
    echo "eza not found, using ls, consider installing eza"
fi


alias k='kubectl'

fpath=(~/.zsh.d/ $fpath)

# cht.sh method
# curl cht.sh/$1 | bat -p -
cht() {
    if [[ -n $( command -v curl ) ]]; then
        if [[ -n $( command -v bat ) ]]; then
            curl cht.sh/$1 | bat -p -
        else
            if [[ -n $( command -v less ) ]]; then
                echo "bat not found, falling back to less"
                curl cht.sh/$1 | less
            else
                echo "less not found, no pager available, using curl only"
                curl cht.sh/$1
            fi
        fi
    else
        echo "curl not found, install curl"
    fi
}

# zoxide
if [[ ! -x $(command -v zoxide) ]];then 
  echo "zoxide not found, installing zoxide now" 
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
fi
if [[ -x $(command -v zoxide) ]];then
  # exclude x-cmd.root
  export _ZO_EXCLUDE_DIRS="$HOME/.x-cmd.root/*:"
  eval "$(zoxide init zsh)"
  alias cd=z
fi


# # if in MSYS, allow completion for /c /d etc drives
# if [[ "$(uname -s)" =~ ^MSYS_NT.* ]]; then
#   drives=$(mount | sed -rn 's#^[A-Z]: on /([a-z]).*#\1#p' | tr '\n' ' ')
#   zstyle ':completion:*' fake-files /: "/:$drives"
#   unset drives
# fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

transfer_url="https://al:Correct-Rockslide6-Depletion@tsh.qaaq.cc"
transfer(){ if [ $# -eq 0 ];then echo "No arguments specified.\nUsage:\n transfer <file|directory>\n ... | transfer <file_name>">&2;return 1;fi;if tty -s;then file="$1";file_name=$(basename "$file");if [ ! -e "$file" ];then echo "$file: No such file or directory">&2;return 1;fi;if [ -d "$file" ];then file_name="$file_name.zip";(cd "$file"&&zip -r -q - .)|curl --progress-bar --upload-file "-" "$transfer_url/$file_name"|tee /dev/null;else cat "$file"|curl --progress-bar --upload-file "-" "$transfer_url/$file_name"|tee /dev/null;fi;else file_name=$1;curl --progress-bar --upload-file "-" "$transfer_url/$file_name"|tee /dev/null;fi;}
alias tsh=transfer

# hide % at end of print
export PROMPT_EOL_MARK=''
