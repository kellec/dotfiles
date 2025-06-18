# Custom ZSH Prompt Configuration
# Displays: current directory + git branch (if applicable) + git status indicators

# git:
# %b => current branch
# %a => current action (rebase/merge)

# prompt:
# %F => color dict
# %f => reset color
# %~ => current path
# %* => time
# %n => username
# %K => background color
# %k => reset background color
# %B => bold
# %b => reset bold
# %u => underline
# %U => reset underline

# Enable prompt substitution
setopt PROMPT_SUBST

autoload -Uz vcs_info

# Define colors
autoload -U colors && colors

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' formats ' %b'

bold() {
    echo -n "%B$1%b"
}

write() {
    local color content bold_flag
    [[ -n "$1" ]] && color="%F{$1}" || color="%f"
    [[ -n "$2" ]] && content="$2" || content=""
    [[ -n "$3" ]] && bold_flag="$3" || bold_flag=""

    [[ -z "$2" ]] && content="$1"

    echo -n "$color"
    [[ "$bold_flag" == "true" || "$bold_flag" == "1" ]] && echo -n "%B"
    echo -n "$content"
    [[ "$bold_flag" == "true" || "$bold_flag" == "1" ]] && echo -n "%b"
    echo -n "%{%b%f%}"
}


git_prompt_icon() {
  echo "%{$fg[magenta]%}(%{$fg[cyan]%}%{$reset_color%}"
}

is_git() {
    [[ $(command git rev-parse --is-inside-work-tree 2>/dev/null) == true ]]
}

# Git prompt function
git_prompt_info() {
  cd -q "$1"
    is_git || return

    vcs_info

    local git_branch="$vcs_info_msg_0_"
    git_branch="${git_branch#heads/}"
    git_branch="${git_branch/.../}"

    [[ -z "$git_branch" ]] && return

    local INDEX git_status=""

    GIT_SYMBOL=" "
    GIT_STATUS_ADDED=$(write '002' ' ')
    GIT_STATUS_MODIFIED=$(write '003' ' ')
    GIT_STATUS_UNTRACKED=$(write '009' ' ')
    GIT_STATUS_RENAMED=$(write '208' ' ')
    GIT_STATUS_DELETED=$(write '161' '󰮉 ')
    GIT_STATUS_STASHED=$(write '003' ' ')
    GIT_STATUS_UNMERGED=$(write '016' '󰧁 ')
    GIT_STATUS_AHEAD=$(write '012' ' ')
    GIT_STATUS_BEHIND=$(write '011' ' ')
    GIT_STATUS_DIVERGED=$(write '012' '󰧈 ')
    GIT_STATUS_CLEAN=$(write '002' ' ')

    INDEX=$(command git status --porcelain -b 2>/dev/null)

    # Check for untracked files
    if $(echo "$INDEX" | command grep -E '^\?\? ' &> /dev/null); then
        git_status="$GIT_STATUS_UNTRACKED$git_status"
    fi

    # Check for staged files
    if $(echo "$INDEX" | command grep '^A[ MDAU] ' &> /dev/null); then
        git_status="$GIT_STATUS_ADDED$git_status"
    elif $(echo "$INDEX" | command grep '^M[ MD] ' &> /dev/null); then
        git_status="$GIT_STATUS_ADDED$git_status"
    elif $(echo "$INDEX" | command grep '^UA' &> /dev/null); then
        git_status="$GIT_STATUS_ADDED$git_status"
    fi

    # Check for modified files
    if $(echo "$INDEX" | command grep '^[ MARC ]M ' &> /dev/null); then
        git_status="$GIT_STATUS_MODIFIED$git_status"
    fi

    # Check for renamed files
    if $(echo "$INDEX" | command grep '^R[ MD] ' &> /dev/null); then
        git_status="$GIT_STATUS_RENAMED$git_status"
    fi

    # Check for deleted files
    if $(echo "$INDEX" | command grep '^[MARCDU ]D ' &> /dev/null); then
        git_status="$GIT_STATUS_DELETED$git_status"
    elif $(echo "$INDEX" | command grep '^D[ UM] ' &> /dev/null); then
        git_status="$GIT_STATUS_DELETED$git_status"
    fi

    # Check for stashes
    if $(command git rev-parse --verify refs/stash >/dev/null 2>&1); then
        git_status="$GIT_STATUS_STASHED$git_status"
    fi

    # Check for unmerged files
    if $(echo "$INDEX" | command grep '^U[UDA] ' &> /dev/null); then
        git_status="$GIT_STATUS_UNMERGED$git_status"
    elif $(echo "$INDEX" | command grep '^AA ' &> /dev/null); then
        git_status="$GIT_STATUS_UNMERGED$git_status"
    elif $(echo "$INDEX" | command grep '^DD ' &> /dev/null); then
        git_status="$GIT_STATUS_UNMERGED$git_status"
    elif $(echo "$INDEX" | command grep '^[DA]U ' &> /dev/null); then
        git_status="$GIT_STATUS_UNMERGED$git_status"
    fi

    # Check whether branch is ahead
    local is_ahead=false
    if $(echo "$INDEX" | command grep '^## [^ ]\+ .*ahead' &> /dev/null); then
        is_ahead=true
    fi

    # Check whether branch is behind
    local is_behind=false
    if $(echo "$INDEX" | command grep '^## [^ ]\+ .*behind' &> /dev/null); then
        is_behind=true
    fi

    # Check wheather branch has diverged
    if [[ "$is_ahead" == true && "$is_behind" == true ]]; then
        git_status="$GIT_STATUS_DIVERGED$git_status"
    else
        [[ "$is_ahead" == true ]] && git_status="$GIT_STATUS_AHEAD$git_status"
        [[ "$is_behind" == true ]] && git_status="$GIT_STATUS_BEHIND$git_status"
    fi

    [[ -n "$git_status" ]] || git_status="$GIT_STATUS_CLEAN"

    write null "on "
    write 'cyan' "$git_branch" true
    write 'blue' " ["
    bold " $git_status"
    write 'blue' "]"
}

# Directory path function (shortens home directory to ~)
prompt_dir() {
  echo "%{$fg[red]%}%~%{$reset_color%}"
}

prompt_user() {
  # green bold  
  echo "%{$bg[cyan]%}%{$fg[black]%} %n %{$reset_color%}%{$fg[cyan]%}$(prompt_separator_right)%{$reset_color%}"
}

# current time with milliseconds
current_time() {
  echo "%{$fg[yellow]%}\ue385 %*%{$reset_color%}"
}

prompt_arrow() {
  echo "%{$fg[magenta]%}\ue007 %{$reset_color%}"
}

prompt_separator_right() {
  echo "\ue0c4"
}

prompt_separator_left() {
  echo "\ue0c7"
}

# Build the prompt
# Format: [user] [directory] (git_branch status)
#         $ 
PROMPT='%B$(prompt_user) $(prompt_dir) $(git_prompt_info)%b at $(current_time)
 $(prompt_arrow) → '

# Right prompt with timestamp (optional)
RPROMPT='%{$fg[gray]%}%T%{$reset_color%}'
