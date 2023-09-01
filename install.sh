#!/bin/bash

ROOT_DIR="$PWD"

# Define the URL of the zip file you want to download
URL_TO_ZIP_FILE="https://github.com/oracle/content-and-experience-toolkit/archive/master.zip"

# check if install forlder exists
# if not create it
if [ ! -d "./install" ]; then
  echo "Creating install folder..."
  mkdir "./install"
fi
# Download the zip file
echo "Downloading zip file from $URL_TO_ZIP_FILE..."
wget "$URL_TO_ZIP_FILE" -P "./install"

# Check if the download was successful
if [ $? -eq 0 ]; then
  echo "Download completed successfully."
else
  echo "Download failed."
  exit 1
fi

# Unzip the downloaded file
echo "Unzipping the downloaded file..."
unzip "install/master.zip" -d "./install"

# remove the zip file
echo "Removing the downloaded zip file..."
rm "./install/master.zip"

# Check if the unzip operation was successful
if [ $? -eq 0 ]; then
  echo "Unzip completed successfully."
else
  echo "Unzip failed."
  exit 1
fi

cd "$ROOT_DIR/install/content-and-experience-toolkit-master/sites"
echo "Installing npm packages..."
npm install
echo "Creating symbolic link..."
sudo ln -s $PWD/node_modules/.bin/cec /usr/local/bin/cec

cd $ROOT_DIR
echo "Instaling Project..."
echo "+-------------------------+"
read -p "Enter Project Name: " projectname
echo "+-------------------------+"
echo "Creating Project..."
mkdir $projectname
cd $projectname
echo "Creating Project Structure..."
cec install
echo "+-------------------------+"
echo "Project Created Successfully"
read -p "Do you wanna integrate git Y[yes]/n[no]: " choice
case "$choice" in
  y|Y ) echo "Integrating git..."
      read -p "Enter git repository url: " giturl
      rm -r ./src
      git clone $giturl ./src
      echo "Git Integrated Successfully"
      
      ;;
  n|N ) echo "Git Integration Skipped"
        ;;
  * ) echo "Invalid Option"
      ;;
esac
