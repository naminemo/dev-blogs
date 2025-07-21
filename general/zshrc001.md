

`nano .zshrc`


```zsh
autoload -Uz vcs_info

# 啟用 Git 分支資訊
precmd() { vcs_info }

# 顯示格式設定
setopt prompt_subst
PROMPT='%F{magenta}🐻 (〃∀〃)~♡  %F{cyan}🏠 %1~ %F{yellow}${vcs_info_msg_0_} %F{green}❯ %f'

# Git 分支樣式
zstyle ':vcs_info:git:*' formats '🐣 %b'

```