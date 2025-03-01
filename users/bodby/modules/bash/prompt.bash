set -o vi

__bash_prompt() {
  local status="$?"

  local user_col='\[\e[0;34m\]'
  local dir_col='\[\e[0;37m\]'
  local git_col='\[\e[1;97m\]'
  local nix_col='\[\e[0;36m\]'
  local diff_col='\[\e[0;37m\]'
  local punc_col='\[\e[0;36m\]'
  local err_col='\[\e[0;31m\]'
  local reset='\[\e[0m\]'

  local separator="${punc_col} : ${reset}"
  local arrow="${punc_col}>${reset} "

  local user="${user_col}\u${clear}"

  local formatted_dir=""
  if [ "$PWD" = "$HOME" ]; then
    formatted_dir="home/${USER}"
  else
    formatted_dir="${PWD/$HOME\//''}"
  fi

  # formatted_dir="${formatted_dir//\//${punc_col}\/${dir_col}}"

  local cwd="${dir_col}${formatted_dir}${reset}"

  local git=""
  local git_add=""
  local git_mod=""
  local git_rm=""
  local branch="$(git branch --show-current 2>/dev/null)"

  if [ -n "$branch" ]; then
    branch=" #${branch}"
    git="${git_col}${branch}${reset}"

    while read line; do
      local file_status=${line:0:1}
      local added=$(echo $file_status | grep -c 'A')
      local modified=$(echo $file_status | grep -c 'M')
      local removed=$(echo $file_status | grep -c 'D')

      if [ "$added" != 0 ]; then ((git_add=git_add+1)); fi
      if [ "$modified" != 0 ]; then ((git_mod=git_mod+1)); fi
      if [ "$removed" != 0 ]; then ((git_rm=git_rm+1)); fi
    done <<< $(git diff --name-status HEAD 2>/dev/null)

    if [ "$git_add" != "" ]; then git_add=" +$git_add"; fi
    if [ "$git_mod" != "" ]; then git_mod=" ~$git_mod"; fi
    if [ "$git_rm" != "" ]; then git_rm=" -$git_rm"; fi

    if [ -n "$git_add" ] || [ -n "$git_mod" ] || [ -n "$git_rm" ]; then
      git="${git}${diff_col}${git_add}${git_mod}${git_rm}"
    fi
  fi

  local nix_shell=""
  if [ -n "$name" ] || [ -n "$IN_NIX_SHELL" ]; then
    nix_shell="${nix_col}?${reset}"
  fi

  local prompt_status=""
  if [ "$status" != 0 ]; then
    prompt_status="${err_col}${status} ${reset}"
  fi

  export PS1="${user}${nix_shell}${separator}${cwd}${git}${end}\n${prompt_status}${arrow}"
  export PS2="${punc_col}|${reset} "
}

export PROMPT_COMMAND='__bash_prompt'
