
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git zkubectl docker mvn fzf zsh-autosuggestions zsh-syntax-highlighting)

source $HOME/.oh-my-zsh/oh-my-zsh.sh

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
