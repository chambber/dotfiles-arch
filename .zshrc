# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

autoload -Uz add-zsh-hook
autoload -Uz compinit
compinit

source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/git/git.plugin.zsh
source ~/.zsh/git-commit/git-commit.plugin.zsh
source ~/.zsh/jira/jira.plugin.zsh
source ~/.zsh/zsh-histdb/sqlite-history.zsh
source ~/.zsh/magic-enter/magic-enter.plugin.zsh

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

_zsh_autosuggest_strategy_histdb_top() {
    local query="
        select commands.argv from history
        left join commands on history.command_id = commands.rowid
        left join places on history.place_id = places.rowid
        where commands.argv LIKE '$(sql_escape $1)%'
        group by commands.argv, places.dir
        order by places.dir != '$(sql_escape $PWD)', count(*) desc
        limit 1
    "
    suggestion=$(_histdb_query "$query")
}
ZSH_AUTOSUGGEST_STRATEGY=histdb_top

dev() {
  if [ -z "$1" ]; then
    echo "You forgot to supply the tool"
    return 1
  fi
  if [ -z "$2" ]; then
    echo "You forgot to supply the action"
    return 1
  fi
  docker compose -f ~/develop/infracommerce/devops/$1/docker-compose.yaml ${@:2}
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

. /opt/asdf-vm/asdf.sh

export PATH=$HOME/.local/bin:$HOME/.cargo/bin:$PATH

# pnpm
export PNPM_HOME="/home/chamber/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
alias config='/usr/bin/git --git-dir=/home/chamber/.cfg/ --work-tree=/home/chamber'
