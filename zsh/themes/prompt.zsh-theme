# purple username
username() {
   echo "%{$fg[blue]%}%n%{$reset_color%}"
}

# current directory, two levels deep
directory() {
   echo "%{$fg[yellow]%}%3~%{$reset_color%}"
}

# current time with milliseconds
current_time() {
  echo "%{$fg[magenta]%}%*%{$reset_color%}"
}

# returns 👾 if there are errors, nothing otherwise
return_status() {
   echo "%(?..👾)"
}

# set the git_prompt_info text
ZSH_THEME_GIT_PROMPT_PREFIX="%{$FG[241]%} "
ZSH_THEME_GIT_PROMPT_SUFFIX=" "
ZSH_THEME_GIT_PROMPT_DIRTY=" ✖"
ZSH_THEME_GIT_PROMPT_CLEAN=" "

prompt_prefix() {
  echo "%{$fg[cyan]%}  → "
}

# first line of prompt
precmd() {
  print -P '%B$(username) $(directory) $(git_prompt_info)%b $(current_time)$(return_status) '
}

# second line of prompt (command prefix)
PROMPT='$(prompt_prefix)'
RPROMPT=''