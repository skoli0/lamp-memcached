#!/bin/bash
set -x
# -------------------------------------------------------------------------------------------------------------------------------
# [Author] Sandeep Koli
#          Open an app link using HTTP in default web browser
# -------------------------------------------------------------------------------------------------------------------------------
echo "Curl to app link in case server is installed without GUI..."
curl -L -s http://localhost:8080/app

echo "Open the same app link with default web browser in case server is installed with GUI..."
export DISPLAY=:0.0
sh -c "xdg-open http://localhost:8080/app &"
