# syntax: bash

export PATH="$HOME/.local/bin:$PATH"

alias nuke-pyc='find ./$(git rev-parse --show-cdup) -name "*.pyc" -delete'
#alias gl='git log --pretty=oneline'
alias no-lc-env='unset $(env | grep LC_ | cut -f 1 -d '=' | xargs)'
alias p='makepasswd --count=5 --minchars=12 --maxchars=12'

if ! command -v exa &> /dev/null; then
    printf "Install exa https://github.com/ogham/exa/releases\n"
else
    alias ls='exa --icons --group-directories-first -lag --git'
    alias a="exa -abghl --git --color=automatic"
fi

if [ ! -f /usr/lib/python3/dist-packages/pygments/cmdline.py ]; then
    printf "Install pygments; sudo apt install python3-pygments\n"
else
    alias c='/usr/bin/python3 -c "from pygments.cmdline import main; main()" -O style=paraiso-dark -f console256 -g'
fi

if ! command -v keychain &> /dev/null; then
    printf "Install keychain; sudo apt install keychain\n"
else
    keychain -q --nogui $HOME/.ssh/id_rsa
    source $HOME/.keychain/$HOST-sh
fi

function set_win_title() {
    echo -ne "\033]0; $1 \007"
}

if [ -n "$BASH_VERSION" ]; then
    shell_variant="bash"
else
    shell_variant="zsh"

    unsetopt share_history
fi

if ! command -v starship &> /dev/null; then
    printf "Install starship; sh -c \"\$(curl -fsSL https://starship.rs/install.sh)\"\n"
else
    eval "$(starship init $shell_variant)"
fi

if [ -d "$HOME/google-cloud-sdk" ]; then
    # The next line updates PATH for the Google Cloud SDK.
    source "$HOME/google-cloud-sdk/path.${shell_variant}.inc"
    # The next line enables shell command completion for gcloud.
    source "$HOME/google-cloud-sdk/completion.${shell_variant}.inc"
    export CLOUDSDK_HOME="$HOME/google-cloud-sdk/"
fi

if command -v kubectl &> /dev/null; then
    kubectl completion $shell_variant > "$HOME/.${shell_variant}-completion-kubectl"
    source "$HOME/.${shell_variant}-completion-kubectl"
    alias k-use-context-minikube='kubectl config use-context minikube'
fi

if command -v helm &> /dev/null; then
    helm completion $shell_variant > "$HOME/.${shell_variant}-completion-helm"
    source "$HOME/.${shell_variant}-completion-helm"
fi

if [ -d "$HOME/.pyenv" ]; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv init --path)"
    #eval "$(pyenv virtualenv-init -)"
fi

if [ -d "$HOME/.poetry" ]; then
    export PATH="$HOME/.poetry/bin:$PATH"
fi

if [ -d "$HOME/.nvm" ]; then
    export NVM_DIR="$HOME/.nvm"
    # slow why!
    #[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    #[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

function kbash () {
    kubectl exec $@ -it env COLUMNS=$(tput cols) LINES=$(tput lines) TERM=xterm bash
}

function _kbash () {
    local cur prev opts
    local template
    template="{{ range .items  }}{{ .metadata.name }} {{ end }}"
    if opts=$(kubectl get -o template --template="${template}" "pod" 2>/dev/null); then

        COMPREPLY=()
        cur="${COMP_WORDS[COMP_CWORD]}"
        prev="${COMP_WORDS[COMP_CWORD-1]}"

        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
        return 0
    fi

}

complete -F _kbash kbash

function pushmerge () {
        local branch=$1
        local target=$2
        git push origin $branch -o merge_request.create -o merge_request.target=$target
}

function k8sdashboardtoken () {
        token=$(microk8s.kubectl -n kube-system get secret | grep default-token | cut -d " " -f1) && microk8s.kubectl -n kube-system describe secret $token
}

export EDITOR='vim'
