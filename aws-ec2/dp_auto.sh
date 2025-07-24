#!/bin/bash

# Stopping and deleting the PM2 process
echo "Stopping PM2 process..."
pm2 stop 0
pm2 delete 0

# Removing old directories
echo "Removing old directories..."
sudo rm -rf <repo_name>
sudo rm -rf current
sudo rm -rf source

# Cloning the repository - Replace <URL> with your repository URL
# Ensure you've set up Git SSH or credential caching if you're not embedding the PAT directly
echo "Cloning repository..."
git clone https://<git_account_token>@github.com/DigniteStudios/<repo_name>.git

# Installing dependencies
echo "Installing npm dependencies..."
cd <repo_name> || exit
npm install

# Starting the app with PM2
echo "Starting the app with PM2..."
pm2 start index.js
pm2 save

echo "Deployment completed successfully."