#!/bin/bash

CONFIG_FILE="/data/options.json"
DOWNLOAD_DIR="/data/resources"
TIMESTAMP_FILE="/data/last_updated.txt"

mkdir -p "$DOWNLOAD_DIR"

CURRENT_TIME=$(date +%s)
LAST_UPDATED=0
if [ -f "$TIMESTAMP_FILE" ]; then
  LAST_UPDATED=$(cat "$TIMESTAMP_FILE")
fi

FORCE=$(jq -r '.force_update' "$CONFIG_FILE")
do_update=false

if [ "$FORCE" == "true" ]; then
  do_update=true
  jq '.force_update = false' "$CONFIG_FILE" > "$CONFIG_FILE.tmp" && mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"
else
  do_update=true
fi

if [ "$do_update" = true ]; then
  echo "[Prepper Add-on] Updating sources..."

  jq -c '.sources[]' "$CONFIG_FILE" | while read -r source; do
    url=$(echo "$source" | jq -r '.url')
    expected_sha=$(echo "$source" | jq -r '.sha256 // empty')
    filename=$(basename "$url")
    dest="$DOWNLOAD_DIR/$filename"

    wget -q -O "$dest" "$url"
    if [ -n "$expected_sha" ]; then
      actual_sha=$(sha256sum "$dest" | awk '{print $1}')
      if [ "$expected_sha" != "$actual_sha" ]; then
        echo "SHA256 mismatch for $filename"
        rm -f "$dest"
      fi
    fi
  done

  for mirror in $(jq -c '.github_mirrors[]' "$CONFIG_FILE"); do
    repo=$(echo "$mirror" | jq -r '.repo')
    branch=$(echo "$mirror" | jq -r '.branch')
    folder=$(echo "$mirror" | jq -r '.folder')
    repo_name=$(basename "$repo" .git)
    clone_path="/data/resources/github/$repo_name"

    if [ ! -d "$clone_path" ]; then
      git clone --branch "$branch" --depth 1 "$repo" "$clone_path"
    else
      cd "$clone_path" && git pull origin "$branch"
    fi

    ln -sf "$clone_path/$folder" "/data/resources/$repo_name-$folder"
  done

  echo "$CURRENT_TIME" > "$TIMESTAMP_FILE"
fi
