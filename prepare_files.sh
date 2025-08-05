#!/bin/bash
set -e

echo "Cleaning old files..."
rm -rf New.zip unzipped
mkdir -p unzipped

echo "Downloading ZIP..."
curl -L -o New.zip "https://github.com/AKTECHLEARN/TESTZIP/raw/main/New.zip"

echo "Unzipping..."
unzip New.zip -d unzipped
