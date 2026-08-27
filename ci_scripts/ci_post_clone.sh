#!/bin/zsh
set -euo pipefail

cd "${CI_PRIMARY_REPOSITORY_PATH:-$(pwd)}"
export HOMEBREW_NO_AUTO_UPDATE=1

if ! command -v xcodegen >/dev/null 2>&1; then
  brew install xcodegen
fi

xcodegen generate
python3 scripts/check_scaffold.py
python3 scripts/check_repository.py
