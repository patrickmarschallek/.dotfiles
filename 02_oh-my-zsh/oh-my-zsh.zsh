
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git docker mvn fzf kubectl zsh-autosuggestions zsh-syntax-highlighting)
export ZSH=$HOME/.oh-my-zsh
source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
