# syntax: sh

if ! command -v starship &> /dev/null; then
    printf "Install starship; sh -c \"\$(curl -fsSL https://starship.rs/install.sh)\"\n"
    PROMPT="%{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m %{$fg[yellow]%}%~ %{$reset_color%}%% "
else
    eval "$(starship init $shell_variant)"
fi
