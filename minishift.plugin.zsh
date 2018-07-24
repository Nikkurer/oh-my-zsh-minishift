ZSH_MINISHIFT_STATUS=$( minishift status | awk '$1=="Minishift:" {print $2}' )

if [ "${ZSH_MINISHIFT_STATUS}" = "Running" ]
then
  eval "$(minishift oc-env)"
  eval "$(minishift docker-env)"
fi

eval "$(oc completion zsh)"
