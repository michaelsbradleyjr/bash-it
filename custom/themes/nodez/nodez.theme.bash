# Author: Michael Bradley (https://github.com/michaelsbradleyjr)
# Based on the zork theme:
# https://github.com/Bash-it/bash-it/blob/master/themes/zork/zork.theme.bash

SCM_THEME_PROMPT_PREFIX=""
SCM_THEME_PROMPT_SUFFIX=""

SCM_THEME_PROMPT_DIRTY=" ${bold_red}✗${normal}"
SCM_THEME_PROMPT_CLEAN=" ${bold_green}✓${normal}"
SCM_GIT_CHAR="${bold_green}±${normal}"
SCM_SVN_CHAR="${bold_cyan}⑆${normal}"
SCM_HG_CHAR="${bold_red}☿${normal}"

BRACKET_COLOR="${blue}"

__nodez_char_node="${bold_green}🄽 ${normal}"
__nodez_char_npm=📦
__nodez_char_yarn="🗳 "

__nodez_ne() {
    local env=
    if [[ -v NVM_DIR ]]; then
        env="nvm"
    fi
    if [[ -v NODE_VIRTUAL_ENV ]]; then
        env="${NODE_VIRTUAL_ENV##*/}"
    fi
    if [[ "$env" != "" ]]; then
        env="${BRACKET_COLOR}[${bold_yellow}$env${normal}"
        if [[ ! -v NODE_VERSION ]]; then
            env+="${BRACKET_COLOR}]${normal}"
        fi
        echo "$env"
    fi
}

__nodez_nv() {
    if [[ -v NODE_VERSION ]]; then
        local nv="＝${__nodez_char_node}${NODE_VERSION}"
        local npm_version=$(npm --version)
        if [[ "$npm_version" != "$NPM_VERSION" ]]; then
            export NPM_VERSION=$npm_version
        fi
        nv+="${__nodez_char_npm}${NPM_VERSION}"
        echo "$nv"
    fi
}

__nodez_yv() {
  if [[ -v NODE_VERSION ]]; then
    local yarn_version=$(yarn --version 2>/dev/null)
    local yv=""
    if [[ -n "$yarn_version" ]]; then
      yv+="${__nodez_char_yarn}${yarn_version}${BRACKET_COLOR}]${normal}"
    else
      yv+="${BRACKET_COLOR}]${normal}"
    fi
    echo "$yv"
  fi
}

__nodez_scm_prompt() {
    [[ $(scm_char) != $SCM_NONE_CHAR ]] \
        && echo "${BRACKET_COLOR}[$(scm_char)${BRACKET_COLOR}][${normal}$(scm_prompt_info)${BRACKET_COLOR}]${normal}"
}

case $TERM in
    xterm*)
        __nodez_title="\[\033]0;\w\007\]" ;;
    *)
        __nodez_title="" ;;
esac

__nodez_ve(){
    [[ -n "$VIRTUAL_ENV" ]] \
        && echo "(${bold_purple}${VIRTUAL_ENV##*/}${BRACKET_COLOR})${normal}"
}

prompt() {
    local host="${green}\h${normal}";
    PS1="${__nodez_title}${BRACKET_COLOR}┌─"
    PS1+="$(__nodez_ve)"
    PS1+="${BRACKET_COLOR}[$host${BRACKET_COLOR}]"
    PS1+="$(__nodez_ne)$(__nodez_nv)$(__nodez_yv)"
    PS1+="$(__nodez_scm_prompt)"
    PS1+="${BRACKET_COLOR}[${cyan}\\w${BRACKET_COLOR}]${normal}"
    PS1+="
${BRACKET_COLOR}└─▪${normal} "
}

PS2="${BRACKET_COLOR}└─▪${normal} "
PS3="${BRACKET_COLOR}>> ${normal}"

safe_append_prompt_command prompt
