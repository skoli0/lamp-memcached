#!/bin/bash
set -x
# ------------------------------------------------------------------------------
# [Author] skoli0
#          Open an app link using HTTP in default web browser
# ------------------------------------------------------------------------------
echo "Curl to app link in case server is installed without GUI..."
curl -L -s http://localhost:8080/app

# Open an app link using HTTP in default web browser
echo "Open the same link in default web browser in case server is installed with GUI..."

# Display environment variable
export DISPLAY=:0.0
sh -c "xdg-open http://localhost:8080/app &"
