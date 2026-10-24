#!/bin/sh
# downloads Electron for Flight; run once before run.sh
exec "$(dirname "$(readlink -f "$0")")/tools/fetch-electron.sh" "$@"
