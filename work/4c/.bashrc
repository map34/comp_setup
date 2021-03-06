# CLI Colors
export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "
export CLICOLOR=1
alias ls='ls -GFh'
export TERM=xterm-256color

# bash-git-prompt
GIT_PROMPT_ONLY_IN_REPO=0
if [ -f "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh" ]; then
  __GIT_PROMPT_DIR=$(brew --prefix)/opt/bash-git-prompt/share
  source "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh"
fi

# git completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

alias git-diff='git diff --color | sed -E "s/^([^-+ ]*)[-+ ]/\\1/" | less -r'

function GitPruneBranches()
{
   git remote prune origin; git branch -vv | grep ': gone]' | awk '{print $1}' | xargs git branch -D
}
alias git-prune=GitPruneBranches

# NVM Stuff
export NVM_DIR="/Users/map34/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# GO
export GOPATH=${HOME}/go
export GOVERSION=$(brew list go | head -n 1 | cut -d '/' -f 6)
export GOROOT=$(brew --prefix)/Cellar/go/${GOVERSION}/libexec
export PATH=${GOPATH}/bin:$PATH
export PATH=$PATH:/usr/local/sbin
export PATH="$(dirname $(go list -f '{{.Target}}' myitcv.io/react/cmd/reactGen)):$PATH"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# Speed Test from Terminal
alias be='bundle exec'
alias py-speedtest-cli='/Users/map34/personal_projects/adrian_venv/bin/speedtest-cli'

### Docker cleanups
# Kill all running containers.
alias dockerkillall='docker kill $(docker ps -q)'

# Delete all stopped containers.
alias dockercleanc='printf "\n>>> Deleting stopped containers\n\n" && docker rm $(docker ps -a -q)'

# Delete all untagged images.
alias dockercleani='printf "\n>>> Deleting untagged images\n\n" && docker rmi $(docker images -q -f dangling=true)'

# Delete all dangling volumes
alias dockercleanv='printf "\n>>> Delete dangling volumes.\n\n" && docker volume rm $(docker volume ls -qf dangling=true)'

# Delete all stopped containers and untagged images.
alias dockerclean='dockercleanc || true && dockercleani || true && dockercleanv'

# nullify-disk
alias nullify-disk='sync; sudo cat /dev/zero > /tmp/zero; sync; sleep 1; sudo rm -rf /tmp/zero'

# shrink Docker_QCOW2
export DOCKER_QCOW=/Users/map34/Library/Containers/com.docker.docker/Data/com.docker.driver.amd64-linux/Docker.qcow2
alias shrinkdockerqcow='mv ${DOCKER_QCOW} ${DOCKER_QCOW}.BACKUP && qemu-img convert -O qcow2 ${DOCKER_QCOW}.BACKUP ${DOCKER_QCOW} && rm -rf ${DOCKER_QCOW}.BACKUP'

alias cleanlibcache='sudo find ~/Library/Caches/ -type f -delete && sudo find /Library/Caches/ -type f -delete'

# Pyenv
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

# Removes a pip package and its dependencies
pip-autoremove() {
  for dep in $(pip show $1 | grep Requires | sed 's/Requires: //g; s/,//g')
  do
    pip uninstall -y $dep
  done
  pip uninstall -y $1
}

# Removes a pip package and its dependencies
pip3-autoremove() {
  for dep in $(pip3 show $1 | grep Requires | sed 's/Requires: //g; s/,//g')
  do
    pip3 uninstall -y $dep
  done
  pip3 uninstall -y $1
}

export SMARTY_RECIPE_REPO="${HOME}/personal_projects/SmartyRecipe"
alias sr-rebuildim='docker-compose -f ${SMARTY_RECIPE_REPO}/infra/docker_dev/docker-compose.yml -p smarty_recipe build'
alias sr='docker-compose -f ${SMARTY_RECIPE_REPO}/infra/docker_dev/docker-compose.yml -p smarty_recipe up'
alias sr-run='docker-compose -f ${SMARTY_RECIPE_REPO}/infra/docker_dev/docker-compose.yml -p smarty_recipe run --rm webserver bash'
alias sr-py-shell='sr-run -c "source activate TEST && python backend/server/manage.py shell"'
alias sr-up='docker-compose -f ${SMARTY_RECIPE_REPO}/infra/docker_dev/docker-compose.yml -p smarty_recipe up'
alias sr-down='docker-compose -f ${SMARTY_RECIPE_REPO}/infra/docker_dev/docker-compose.yml -p smarty_recipe down'
alias sr-jupyter='docker-compose -f ${SMARTY_RECIPE_REPO}/infra/docker_dev/docker-compose.yml -p smarty_recipe run --rm -p 8888:8888 webserver bash -c "source activate TEST && jupyter notebook --allow-root --notebook-dir=./notebooks --ip=0.0.0.0 --port=8888"'

export VOX_REPO="${HOME}/4c_insights_projects/voxsupFrontend2"
vox-rebuildim() {
  pushd ${VOX_REPO}/dockerfiles/dev_env
    docker-compose rm voxsup_celery voxsup_dev && docker rmi -f voxsup_celery voxsup_dev voxsup_base
    pushd $VOX_REPO
      docker-compose -f dockerfiles/dev_env/docker-compose.yml build
    popd
  popd
}

export COMPOSE_ENV_SSH_DIR=~/.ssh/4c_insights
alias vox-run='docker-compose -f ${VOX_REPO}/dockerfiles/dev_env/docker-compose.yml run --rm voxsup_dev'
alias vox-refresh-auth='vox-run dockerfiles/dev_env/get_latest_auth_dump.bash'
alias vox-refresh-frontend='vox-run dockerfiles/dev_env/build_frontend_deps.bash'
alias vox-prepare='vox-refresh-auth && vox-refresh-frontend'
alias vox="${VOX_REPO}/dockerfiles/dev_env/dev"
alias vox-up="docker-compose -f ${VOX_REPO}/dockerfiles/dev_env/docker-compose.yml up"
alias vox-down='docker-compose -f ${VOX_REPO}/dockerfiles/dev_env/docker-compose.yml down'
alias vox-py-shell='vox-run bash -c "python server/manage.py shell"'
alias vox-restart-celery='docker-compose -f ${VOX_REPO}/dockerfiles/dev_env/docker-compose.yml rm -f -s voxsup_celery rabbitmq && docker-compose -f ${VOX_REPO}/dockerfiles/dev_env/docker-compose.yml up -d voxsup_celery rabbitmq'
alias vox-tunnel-rabbitmq='ssh -i ~/.ssh/4c_insights/id_rsa -f ${LOGNAME}@task-mq.4cinsights.com -L 8888:172.16.1.92:15672 -N'

kill-grep() {
  GREP_SEARCH=${1:-dodol}
  echo "${GREP_SEARCH}"
  for pid in $(ps -ef | grep "${GREP_SEARCH}" | awk '{print $2}'); do
    kill -9 $pid && echo "Killing PID ${pid}...";
  done
}

vox-refresh-account() {
  ACCOUNT_ID=${1:-549755814145}
  vox-run bash -c "python server/manage.py shell << EOF
  from voxsup.pinterest.ads import pinterest_refresh_ad_account
  ret = pinterest_refresh_ad_account.apply(args=['${ACCOUNT_ID}'], kwargs={'force': 'true'})
  exit()
EOF"
}

vox-fetch-4c-related-ads() {
  vox-run bash -c "fab fetch_voxsupads_tables_dump:tables='smart_group smart_group_action_alert_recipient\
  smart_group_alert_config_statuses smart_group_alert_recipients smart_group_alertconfigs smart_group_alerts\
  smart_group_association smart_group_budgeting smart_group_dayparting smart_group_dayparting_schedule\
  smart_group_rules smart_group_rules_actions smart_group_rules_condition smart_group_rules_recipient\
  smart_group_rules_trigger smart_group_schedule smart_group_sportsync smart_group_sportsync_event\
  smart_group_tvsync_feature smart_group_weathersync smart_group_weathersync_condition smart_group_weathersync_location\
  social_labels social_labels_account_association social_labels_account_entity_map ad_naming_convention\
  target_set pinterest_target_group',do_import=True"
}

vox-print-grc-template() {
  REPORT_ID=${1}
  HOST='web1'
  USER='map34'
  vox-remote-py-shell $HOST $USER << EOF
  import json
  col = mongo['automation'].db['report_status_logging'].find_one({
    'grc_template_id': ${REPORT_ID}
  }, {
    'report_template': 1,
    'report_schedule': 1,
    'status': 1,
    'steps': 1,
    '_id': 0
  })
  print json.dumps(col, indent=4)
  exit()
EOF
}

vox-remote-refresh-account() {
  HOST=${1:-data-api}
  USER=${2:-frontend}
  ACCOUNT_ID=${3:-549755814145}
  vox-remote-py-shell $HOST $USER << EOF
  from voxsup.pinterest.views.ads import pinterest_refresh_ad_account
  ret = pinterest_refresh_ad_account.apply(args=['$ACCOUNT_ID'], kwargs={'force': 'true'})
  exit()
EOF
}

vox-remote-search-account() {
  HOST=${1:-data-api}
  USER=${2:-frontend}
  ACCOUNT_NAME=${3:-4C}
  vox-remote-py-shell $HOST $USER << EOF
  import voxsup.scripts.pinterest as s
  s.show_accounts(search="${ACCOUNT_NAME}")
  exit()
EOF
}

vox-remote-ssh() {
  HOST=${1:-data-api}
  USER=${2:-frontend}
  vox-run bash -c "source tmp/scripts.sh && vox-remote-ssh ${HOST} ${USER}"
}

alias vox-purge-celery='docker rm -f devenv_voxsup_celery_1 devenv_rabbitmq_1'

vox-remote-py-shell() {
  HOST=${1:-data-api}
  USER=${2:-frontend}
  COMMAND=${3:-}
  vox-run bash -c "source tmp/scripts.sh && vox-remote-py-shell ${HOST} ${USER} ${COMMAND}"
}

vox-tail-deploy-server-log() {
  HOST=${1:-build}
  vox-run bash -c "ssh -o 'StrictHostKeyChecking no' build@$HOST.4cinsights.com 'tail -F -n500 /files2/software/build_server/log/stdout'"
}

vox-fetch-pint-dump-hourly() {
  MONTHS=${1:-3}
  ACCOUNT_ID=${2:-549755814145}
  vox-run bash -c "fab fetch_pinterest_stats_dump:months=$MONTHS,account=$ACCOUNT_ID,coltype=stats_v2_hourly"
}

vox-fetch-pint-dump-daily() {
  MONTHS=${1:-3}
  ACCOUNT_ID=${2:-549755814145}
  vox-run bash -c "fab fetch_pinterest_stats_dump:months=$MONTHS,account=$ACCOUNT_ID,coltype=stats_v2"
}

vox-fetch-pint-dump-target() {
  MONTHS=${1:-3}
  ACCOUNT_ID=${2:-549755814145}
  vox-run bash -c "fab fetch_pinterest_stats_dump:months=$MONTHS,account=$ACCOUNT_ID,coltype=per_targeting_v2"
}

vox-fetch-pint-account-objects() {
  MONTHS=${1:-12}
  ACCOUNT_ID=${2:-549755814145}
  USER_ID=${3:-426645902107633030}
  vox-run bash -c "fab fetch_pinterest_account_info:months=$MONTHS,account=$ACCOUNT_ID,user_id=$USER_ID"
}

alias vox-deploy-data-api='vox-run bash -c "fab deploy_data_api"'
alias vox-deploy-test='vox-run bash -c "fab deploy_test"'
alias vox-deploy-go='vox-run bash -c "fab deploy_go"'
alias vox-deploy-download='vox-run bash -c "fab deploy_download"'
alias vox-deploy-hotfix='vox-deploy-go && vox-deploy-download'
alias vox-deploy-site='vox-run bash -c "fab deploy_site"'
alias vox-pylint='vox-run bash -c "find server/voxsup -name \"*.py\" | xargs pylint -f parseable --rcfile=./.pylintrc"'

vox-deploy-dev-box() {
  vox-run bash -c "fab deploy_single:branch=$1,server=$2"
}

brew-rm-recursive() {
  brew rm $1 && brew rm $(join <(brew leaves) <(brew deps $1))
}