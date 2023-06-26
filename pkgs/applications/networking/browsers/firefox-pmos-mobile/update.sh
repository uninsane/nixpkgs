#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl git jq nix nixfmt nix-prefetch-git

set -exuo pipefail

SRC_REPO="https://gitlab.com/postmarketOS/mobile-config-firefox"
directory="$(realpath "$(dirname $0)")"

tagged_refs="$(git ls-remote --tags --sort -version:refname "${SRC_REPO}.git")"
tags="$(grep -oE 'refs/tags/[0-9\.]+$' <<< "$tagged_refs")"
latest_tag="$(head -n1 <<< "$tags")"
latest_version="$(cut -d '/' -f 3 <<< "$latest_tag")"
sha256="$(nix-prefetch-git --url "${SRC_REPO}.git" --rev "$latest_version" | jq .sha256)"

echo "updating to ${latest_version}"

curl "$SRC_REPO/-/raw/$latest_version/src/policies.json" > policies.json
nix-instantiate --eval -E "with builtins; fromJSON (readFile ./policies.json) // { version = \"$latest_version\"; sha256 = $sha256; }" > "${directory}/pin.nix"
rm policies.json
nixfmt "${directory}/pin.nix"
