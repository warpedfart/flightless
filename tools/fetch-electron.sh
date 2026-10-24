#!/usr/bin/env bash
# downloads the Electron the client runs on (11.5.0, the last with Flash
# support) from Electron's GitHub releases, checks it against their published
# checksums and unpacks it where run.sh and tools/build.sh expect it:
#
#   tools/fetch-electron.sh [linux] [windows]     (default: this machine's)
#
# linux -> electron/, windows -> electron-win/. macOS: tools/build-mac.sh
# downloads its own.
set -euo pipefail

version=11.5.0
here=$(cd "$(dirname "$0")/.." && pwd)
base=https://github.com/electron/electron/releases/download/v$version

targets=("$@")
if [ ${#targets[@]} -eq 0 ]; then
  case "$(uname -s)" in
    Linux) targets=(linux) ;;
    MINGW*|MSYS*|CYGWIN*) targets=(windows) ;;
    *) echo "pass linux and/or windows" >&2; exit 2 ;;
  esac
fi

for tool in curl unzip sha256sum; do
  command -v "$tool" >/dev/null || { echo "missing $tool" >&2; exit 1; }
done

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
curl -fsSL "$base/SHASUMS256.txt" -o "$work/SHASUMS256.txt"

for target in "${targets[@]}"; do
  case "$target" in
    linux)   platform=linux-x64; dir=electron ;;
    windows) platform=win32-x64; dir=electron-win ;;
    *) echo "unknown target: $target" >&2; exit 2 ;;
  esac
  zip=electron-v$version-$platform.zip
  if [ -e "$here/$dir/version" ] && [ "$(cat "$here/$dir/version")" = "$version" ]; then
    echo "$dir/ already has Electron $version"
    continue
  fi
  echo "downloading $zip"
  curl -fL --progress-bar "$base/$zip" -o "$work/$zip"
  (cd "$work" && grep " \*$zip\$" SHASUMS256.txt | sha256sum -c -)
  rm -rf "$here/$dir"
  mkdir -p "$here/$dir"
  unzip -q "$work/$zip" -d "$here/$dir"
  echo "Electron $version is in $dir/"
done
