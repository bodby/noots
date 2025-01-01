set -o vi

__bash_prompt() {
  local status="$?"
  local first_separator=1

  local user_col='\[\e[0;35m\]'
  local dir_col='\[\e[0;34m\]'
  local git_col='\[\e[1;97m\]'
  local nix_col='\[\e[0;37m\]'
  local diff_col='\[\e[0;37m\]'
  local punc_col='\[\e[0;97m\]'
  local punc_col2='\[\e[0;37m\]'
  local err_col='\[\e[0;95m\]'
  local reset='\[\e[m\]'

  local separator_a="${punc_col2} :: ${reset}"
  local separator_b="${punc_col} (${reset}"
  local separator_c=" "
  local separator_d="${punc_col})${reset}"

  local user="${user_col}\u${clear}"

  local formatted_dir=""
  if [ "$PWD" = "$HOME" ]; then
    formatted_dir="home/${USER}"
  else
    formatted_dir="${PWD/$HOME\//''}"
  fi

  local cwd="${dir_col}${formatted_dir}${reset}"

  local git=""
  local git_add=""
  local git_mod=""
  local git_rm=""
  local branch="$(git branch --show-current 2>/dev/null)"

  if [ -n "$branch" ]; then
    branch="#${branch}"
    local prefix="$separator_c"

    if [ "$first_separator" = 1 ]; then
      prefix="$separator_b"
      first_separator=0
    fi
    git="${prefix}${git_col}${branch}${reset}"

    while read line; do
      local file_status=${line:0:1}
      local added=$(echo $file_status | grep -c 'A')
      local modified=$(echo $file_status | grep -c 'M')
      local removed=$(echo $file_status | grep -c 'D')
      if [ "$added" != 0 ]; then git_add=" +$added"; fi
      if [ "$modified" != 0 ]; then git_mod=" ~$modified"; fi
      if [ "$removed" != 0 ]; then git_rm=" -$removed"; fi
    done <<< $(git diff --name-status HEAD 2>/dev/null)

    if [ -n "$git_add" ] || [ -n "$git_mod" ] || [ -n "$git_rm" ]; then
      git="${git}${diff_col}${git_add}${git_mod}${git_rm}"
    fi
  fi

  local nix_shell=""
  # [ -n "$name" ] ||
  if [ -n "$IN_NIX_SHELL" ]; then
    local prefix="$separator_c"

    if [ "$first_separator" = 1 ]; then
      prefix="$separator_b"
      first_separator=0
    fi
    nix_shell="${prefix}${nix_col}${IN_NIX_SHELL}${reset}"
  fi

  local prompt_status=""
  if [ "$status" != 0 ]; then
    prompt_status="${err_col}${status} ${reset}"
  fi

  local arrow="${punc_col}>${reset} "

  local end=""
  if [ "$first_separator" = 0 ]; then
    end="${separator_d}"
  fi

  PS1="${user}${separator_a}${cwd}${git}${nix_shell}${end}\n${prompt_status}${arrow}"
}

PROMPT_COMMAND='__bash_prompt'
PS2='\[\e[0;97m\]> \[\e[m\]'
