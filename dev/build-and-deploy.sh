#!/bin/bash

# Get this script's directory.
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Run all commands in the context of the script's grandparent directory.
cd ${SCRIPT_DIR}/..

# Build the site.
bundle exec jekyll clean
bundle exec jekyll build

# Push the site's output to `eddings` via `scp`.
rsync --checksum --recursive --verbose --delete-after --delete-excluded _site/ karl@eddings.justdavis.com:/var/apache2/justdavis.com/www/karl

