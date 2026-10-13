#!/usr/bin/env bash
set -euf -o pipefail

# Inputs: REF_TYPE (branch|tag), REF_NAME, COMMIT_SHA, DEFAULT_BRANCH
short_sha="${COMMIT_SHA:0:8}"
semver_re='^v?([0-9]+)\.([0-9]+)\.([0-9]+)(-[0-9A-Za-z.-]+)?(\+[0-9A-Za-z.-]+)?$'

# Highest stable version in the repository that starts with prefix $1
highest() {
  git tag --list | sed -n -E 's/^v?([0-9]+\.[0-9]+\.[0-9]+)(\+.*)?$/\1/p' \
    | grep -E "^${1//./\\.}" | sort -V | tail -n 1
}

tags=()
if [[ "$REF_TYPE" == "branch" && "$REF_NAME" == "$DEFAULT_BRANCH" ]]; then
  tags=("sha-${short_sha}" "$DEFAULT_BRANCH")
elif [[ "$REF_TYPE" == "branch" ]]; then
  slug=$(printf '%s' "$REF_NAME" | tr '[:upper:]' '[:lower:]' | tr -c 'a-z0-9._-' '-' | cut -c1-40)
  tags=("${slug#[-.]}-${short_sha}")
elif [[ "$REF_NAME" =~ $semver_re ]]; then
  major=${BASH_REMATCH[1]} minor=${BASH_REMATCH[2]} patch=${BASH_REMATCH[3]}
  pre=${BASH_REMATCH[4]}
  version="${major}.${minor}.${patch}${pre}"
  tags=("$version")
  if [[ -z "$pre" ]]; then
    [[ "$(highest "${major}.${minor}.")" == "$version" ]] && tags+=("${major}.${minor}")
    [[ "$(highest "${major}.")" == "$version" ]] && tags+=("${major}")
    [[ "$(highest "")" == "$version" ]] && tags+=("latest")
  fi
else
  echo "Tag ${REF_NAME} is not semver: no image" >&2
  exit 0
fi

printf '%s\n' "${tags[@]}"