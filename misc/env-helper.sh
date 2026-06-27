#!/usr/bin/env bash

# e - script stops on error (return !=0)
# u - error if undefined variable
# o pipefail - script fails if one of piped command fails
# x - output each line (debug)
set -euo pipefail

TMP_DIR="$(mktemp -d)"
ZIP_FILE="${1:-}"
ZIP_NAME="envs_backup"

function copy_envs() {
    for dir in ./*/; do
        [ -d "$dir" ] || continue

        env_file="$dir/.env"
        if [ -f "$env_file" ]; then
            cp "$env_file" "${TMP_DIR}/$(basename "$dir")-env"
            echo "Copied .env from $dir"
        fi
    done
}

function generate_zip() {
    zip_name="${ZIP_NAME}_$(date +%Y-%m-%d_%H-%M).zip"
    echo -e "\nCreating zip file..."

    pushd "$TMP_DIR" >/dev/null
    zip -r "$zip_name" .
    popd >/dev/null

    mv "$TMP_DIR/$zip_name" .
    echo -e "\nZip generation completed: ${zip_name}"
}

function restore_envs() {
    zip_to_extract="$1"
    [ -f "$zip_to_extract" ] || {
        echo "Zip file not found"
        exit 1
    }

    tmp_extract="$(mktemp -d)"
    unzip -q "$zip_to_extract" -d "$tmp_extract"

    for env_file in "$tmp_extract"/*-env; do
        project_name="$(basename "$env_file" '-env')"
        dest_dir="./$project_name"

        if [ -d "$dest_dir" ]; then
            cp "$env_file" "${dest_dir}/.env"
            echo "Restored .env for ${project_name}"
        else
            echo "Warning: $dest_dir does not exists, skipping..."
        fi
    done
}

# -----------------------------------------------------------------------------

echo "--- ENV files backup helper ---"
echo ""

if [ -z "$ZIP_FILE" ]; then
    echo -e "Starting backup of .env files...\n"
    copy_envs
    generate_zip
    echo -e "\nBackup finished."
else
    echo -e "Starting restore from zip: ${ZIP_FILE}...\n"
    restore_envs "$ZIP_FILE"
    echo ""
    echo -e "\nRestore finished."
fi
