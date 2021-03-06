#!/bin/bash
#
# Install development prerequisites for source distributions of Drake on macOS.
#
# The development and runtime prerequisites for binary distributions should be
# installed before running this script.

set -euxo pipefail

if [[ "${EUID}" -eq 0 ]]; then
  echo 'ERROR: This script must NOT be run as root' >&2
  exit 1
fi

if ! command -v /usr/local/bin/brew &>/dev/null; then
  echo 'ERROR: brew is NOT installed. Please ensure that the prerequisites for binary distributions have been installed.' >&2
  exit 4
fi

/usr/local/bin/brew update

# TODO(jamiesnape): Remove the below two lines on or after 2020-05-01.
/usr/local/bin/brew uninstall bazelbuild/tap/bazel 2>/dev/null || true
/usr/local/bin/brew untap bazelbuild/tap 2>/dev/null || true

# TODO(jamiesnape): Remove the below line on or after 2020-07-01.
/usr/local/bin/brew cask uninstall font-dejavu-sans 2>/dev/null || true

/usr/local/bin/brew bundle --file="${BASH_SOURCE%/*}/Brewfile" --no-lock

if ! command -v /usr/local/bin/pip3 &>/dev/null; then
  echo 'ERROR: pip3 for python@3.8 is NOT installed. The post-install step for the python@3.8 formula may have failed.' >&2
  exit 2
fi

/usr/local/opt/python@3.8/bin/pip3  install --upgrade --requirement "${BASH_SOURCE%/*}/requirements.txt"
