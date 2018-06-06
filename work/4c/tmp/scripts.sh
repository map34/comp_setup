#!/usr/bin/env bash

vox-remote-ssh() {
  HOST=$1
  USER=$2
  ssh -o 'StrictHostKeyChecking no' ${USER}@${HOST}.4cinsights.com
}

vox-remote-py-shell() {
  HOST=$1
  USER=$2
  COMMAND=$3
  ssh -o 'StrictHostKeyChecking no' ${USER}@${HOST}.4cinsights.com -t 'bash -ic "source /files2/frontend/env/bin/activate && python /files2/frontend/voxsupFrontend2/server/manage.py shell ${COMMAND}"'
}
