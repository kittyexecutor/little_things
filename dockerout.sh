#!/bin/bash
set -euo pipefail

usage() {
  cat <<EOF
Usage:
  $0 <app> <version> <registry>

Description:
  Pulls a Docker image and saves it as compressed tar.gz archive.

Arguments:
  app        Image name (e.g. nginx)
  version    Image tag (e.g. 1.25)
  registry   Registry/repository prefix (e.g. docker.io/library)

Options:
  -h, --help    Show this help message and exit

Example:
  $0 nginx 1.25 docker.io/library
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

if [[ $# -ne 3 ]]; then
  echo "Error: wrong number of arguments"
  echo
  usage
  exit 1
fi

app="$1"
version="$2"
url="$3"

app="$(echo "$app" | xargs)"
version="$(echo "$version" | xargs)"
url="$(echo "$url" | xargs)"

app=$(echo "$app" | tr -d '[:space:]')
version=$(echo "$version" | tr -d '[:space:]')

echo "Try to download: ${url}/${app}:${version}"

docker pull "${url}/${app}:${version}"
docker save "${url}${app}:${version}" | gzip > "${app}-${version}.tar.gz"

echo "Saved to: ${app}-${version}.tar.gz"
