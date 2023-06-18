if status is-interactive
    fish_vi_key_bindings
end

alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
abbr sps 'sudo pacman -S'
abbr ri 'rua install'
abbr nf 'neofetch'
abbr nv 'neovide --multigrid'
abbr nmac 'nmcli --ask d wifi connect'
abbr rsm 'rusty-man'

abbr ga 'git add .'
abbr gs 'git status'
abbr gc 'git commit -m'
abbr gp 'git push'
abbr gd 'git diff'

set -gx EDITOR /usr/bin/nvim
