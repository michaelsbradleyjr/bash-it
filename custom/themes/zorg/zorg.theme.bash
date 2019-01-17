# an amalgam of the zork and rjorgenson themes

SCM_THEME_PROMPT_PREFIX=""
SCM_THEME_PROMPT_SUFFIX=""

SCM_THEME_PROMPT_DIRTY=" ${bold_red}✗${normal}"
SCM_THEME_PROMPT_CLEAN=" ${bold_green}✓${normal}"
SCM_GIT_CHAR="${bold_green}±${normal}"
SCM_SVN_CHAR="${bold_cyan}⑆${normal}"
SCM_HG_CHAR="${bold_red}☿${normal}"

BRACKET_COLOR="${blue}"

# Mysql Prompt
export MYSQL_PS1="(\u@\h) [\d]> "

if [ -z ${INSIDE_EMACS+x} ]; then
  case $TERM in
    xterm*)
      TITLEBAR="\[\033]0;\w\007\]"
      ;;
    *)
      TITLEBAR=""
      ;;
  esac
fi

PS3=">> "

__my_rvm_ruby_version() {
  local gemset=$(echo $GEM_HOME | awk -F'@' '{print $2}')
  [ "$gemset" != "" ] && gemset="@$gemset"
  local version=$(echo $MY_RUBY_HOME | awk -F'-' '{print $2}')
  local full="$version$gemset"
  [ "$full" != "" ] && echo "${BRACKET_COLOR}[${normal}$full${BRACKET_COLOR}]${normal}"
}

is_vim_shell() {
  if [ ! -z "$VIMRUNTIME" ]
  then
    echo "${BRACKET_COLOR}[${cyan}vim shell${BRACKET_COLOR}]${normal}"
  fi
}

modern_scm_prompt() {
  local CHAR=$(scm_char)
  if [ $CHAR = $SCM_NONE_CHAR ]
  then
    return
  else
    echo "${BRACKET_COLOR}[$(scm_char)${BRACKET_COLOR}]\
[${green}$(scm_prompt_info)${BRACKET_COLOR}]${normal}"
  fi
}

is_group_member () {
  local username=$1
  local groupname=$2
  if [[ "$(groups $username)" =~ "$groupname" ]]; then
    return 0
  else
    return 1
  fi
}

my_ve(){
  if [ -n "$VIRTUAL_ENV" ]
  then
    my_ps_ve="${bold_green}$ve${BRACKET_COLOR}";
    echo "($my_ps_ve)";
  fi
  echo "";
}

my_nve(){
  if [ -n "$NODE_VIRTUAL_ENV" ]
  then
    my_ps_nve="${bold_green}$nve${BRACKET_COLOR}";
    echo "($my_ps_nve";
  fi
  echo "";
}

my_nodver(){
  if [ -n "$NODE_VIRTUAL_ENV" ]
  then
    my_ps_nodver="${yellow}$nodver${BRACKET_COLOR}";
    echo "{$my_ps_nodver}";
  fi
  echo "";
}

my_npmver(){
  if [ -n "$NODE_VIRTUAL_ENV" ]
  then
    my_ps_npmver="${cyan}$npmver${BRACKET_COLOR}";
    echo "{$my_ps_npmver})";
  fi
  echo "";
}

make_prompt () {
  local my_ps_norm="${bold_green}\u${normal}";
  local my_ps_sudo="${bold_yellow}\u${normal}";
  local my_ps_root="${bold_red}\u${normal}";
  local my_ps_host="${green}\h${normal}";
  local my_ps_path="${cyan}\w${normal}";

  eval my_ps_user=\$$1

  echo "${TITLEBAR}${BRACKET_COLOR}┌─[$my_ps_user${BRACKET_COLOR}]\
[$my_ps_host${BRACKET_COLOR}]$(modern_scm_prompt)$(__my_rvm_ruby_version)\
${BRACKET_COLOR}$(my_nve)$(my_nodver)$(my_npmver)$(my_ve)\
[${my_ps_path}${BRACKET_COLOR}]$(is_vim_shell)${normal}
${BRACKET_COLOR}└─▪ ${normal}"
}

prompt() {
  if [ -n "$VIRTUAL_ENV" ]; then
    ve=`basename $VIRTUAL_ENV`;
  fi
  if [ -n "$NODE_VIRTUAL_ENV" ]; then
    nve=`basename $NODE_VIRTUAL_ENV`;
    nodver=$(echo $(node --version) | sed 's/^v//')
    npmver=$(npm --version)
  fi
  # nice prompt
  case "`id -u`" in
    0) PS1="$(make_prompt my_ps_root)"
       ;;
    *) if [[ $OSTYPE =~ "darwin" ]]; then
         if $(is_group_member $(id -u -n) "staff"); then
           PS1="$(make_prompt my_ps_sudo)"
         else
           PS1="$(make_prompt my_ps_norm)"
         fi
       else
         if $(is_group_member $(id -u -n) "sudo"); then
           PS1="$(make_prompt my_ps_sudo)"
         else
           PS1="$(make_prompt my_ps_norm)"
         fi
       fi
       ;;
  esac
}

PS2="${BRACKET_COLOR}└─▪ ${normal}"

PROMPT_COMMAND=prompt
