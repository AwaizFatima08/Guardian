#!/bin/bash

echo "Starting Guardian Git update..."

cd ~/guardian || exit

echo "Checking repository status..."
git status

echo "Adding changes..."
git add .

echo "Creating commit..."
git commit -m "Routine Guardian update $(date)"

echo "Pulling latest changes from GitHub..."
git pull origin main

echo "Pushing updates to GitHub..."
git push origin main

echo "Guardian repository successfully updated."

