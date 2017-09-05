#!/bin/bash
set -x

# ------------------------------------------------------------------------------
# [Author] skoli0
#          Open an app link using HTTPS in default web browser
# ------------------------------------------------------------------------------
echo "Curl to app link in case server is installed without GUI..."
curl -L -s "https://localhost:8443/app"

# Open an app link using HTTP in default web browser
echo "Open the same app link with default web browser in case server is installed with GUI..."
export DISPLAY=:0.0
sh -c "xdg-open https://localhost:8443/app &"
