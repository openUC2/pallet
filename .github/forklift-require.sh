#!/usr/bin/env -S bash -eu

type_singular="$1" # either `pallet` or `repository`
path="$2"          # path of a pallet or repo, e.g. `github.com/PlanktoScope/pallet-standard`
version_query="$3" # version query, e.g. `edge` or `main`; pseudoversions are not supported (yet)

case "$type_singular" in
"pallets" | "pallet")
  type_plural="pallets"
  type_singular="pallet"
  ;;
"repositories" | "repository" | "repos" | "repo")
  type_plural="repositories"
  type_singular="repository"
  ;;
esac

prev_version="$(forklift dev pallet "show-$type_singular-version" "$path")"
if [ "$DRY_RUN" = "true" ]; then
  prev_version_lock="$(mktemp -t forklift-version-lock-XXXXX.yml)"
  cp "requirements/$type_plural/$path/forklift-version-lock.yml" "$prev_version_lock"
fi

# Note: updatecli expects that stdout should only contain the version string of the updated version,
# and it should be empty if the version was not changed.
forklift dev pallet "require-$type_singular" "$path@$version_query"
version="$(forklift dev pallet "show-$type_singular-version" "$path")"
if [ "$prev_version" != "$version" ]; then
  echo "$version"
fi

if [ "$DRY_RUN" = "true" ]; then
  cp "requirements/$type_plural/$path/forklift-version-lock.yml" "$prev_version_lock"
fi
