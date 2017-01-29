#!/usr/bin/env bash

# Exit with nonzero exit code if anything fails.
set -e

# Get the dir of this script.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Make a temp dir.
tmp_dir=$(mktemp -d)

# Fetch and extract TeX Live installer.
cd "$tmp_dir" || exit 1
wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
tar -xzf install-tl-unx.tar.gz
cd install-tl-20* || exit 1

# Install TeX Live using provided custom profile.
./install-tl --profile="$DIR/texlive.profile"

# Post install config.
export PATH=/tmp/texlive/bin/x86_64-linux:$PATH
# MEMO: "/tmp/texlive" is defined as root in "texlive.profile".

# Install extra packages from provided list.
readarray -t texlive_packages < "$DIR/texlive.packages"
tlmgr install "${texlive_packages[@]}"

# NOTE: we do no cleanup, but this is meant
#   for a simple Travis session, so it's ok.
