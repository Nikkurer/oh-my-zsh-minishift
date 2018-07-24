ZSH_MINISHIFT_CACHE=$( dirname $0 )
ZSH_MINISHIFT_STATUS=$( minishift status | awk '$1=="Minishift:" {print $2}' )
ZSH_OPENSHIFT_STATUS=$( minishift status | awk '$1=="OpenShift:" {print $2}' )

_minishift_cache()
{
  cmd=$1
  file=$2
  age=$3

  if [ -e "${file}" ]
  then
    if [ "$(( $(date +"%s") - $(stat -c "%Y" ${file}) ))" -gt "${age}" ]
    then
      rm -f "${file}"
      eval "${cmd}" | tee "${file}"
    else
      cat "${file}"
    fi
  else
    eval "${cmd}" | tee "${file}"
  fi
}

if [ "${ZSH_MINISHIFT_STATUS}" = "Running" ] && [ "${ZSH_OPENSHIFT_STATUS}" = "Running" ]
then
  source <( _minishift_cache "minishift oc-env"     "${ZSH_MINISHIFT_CACHE}/.oc-env.cache"     "86400" )
  source <( _minishift_cache "oc completion zsh"    "${ZSH_MINISHIFT_CACHE}/.oc-comp.cache"    "86400" )
  source <( _minishift_cache "minishift docker-env" "${ZSH_MINISHIFT_CACHE}/.docker-env.cache" "86400" )
else
  echo "$( basename $0 ): Minishift / OpenShift not running"
fi
