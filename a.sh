#!/bin/bash

if ! command -v gh &> /dev/null; then
    echo "GitHub CLI 'gh' not found. Downloading and installing the latest version..."
    
    # Get the latest release version number from GitHub API
    latest_version=$(curl -s https://api.github.com/repos/cli/cli/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
    
    # Download the latest release
    wget "https://github.com/cli/cli/releases/download/${latest_version}/gh_${latest_version#v}_linux_amd64.tar.gz"
    
    # Extract and install
    tar -xvf "gh_${latest_version#v}_linux_amd64.tar.gz"
    sudo mv gh_*_linux_amd64/bin/gh /usr/local/bin/
    
    echo "GitHub CLI 'gh' version ${latest_version} installed successfully."
else
    echo "GitHub CLI 'gh' is already installed."
fi








source_folder="."
rm -rf h870/* h872/* us997/* 
rm Evolution-X/*.zip
rm Evolution-X/*.img
rm Evolution-X/*.txt
#crave ssh -- ls


find out/target/product/ -maxdepth 1 -type f -name '*.zip' > filelist.txt
find out/target/product/ -mindepth 1 -maxdepth 1 -type d | while read dir; do
  find "$dir" -maxdepth 1 -type f -name '*.zip'
done >> filelist.txt
sed -i 's|^out/target/product/||' filelist.txt
rsync -av --files-from=filelist.txt --relative out/target/product/ ./
















# Define directories
SOURCE_DIR="out/target/product/"
DEST_DIR="./"

# Create the destination directory if it doesn't exist
mkdir -p "$DEST_DIR"

# Find recovery.img files at the top level of SOURCE_DIR and subdirectories
find "$SOURCE_DIR" -maxdepth 1 -type f -name 'recovery.img' > filelist.txt
find "$SOURCE_DIR" -mindepth 1 -maxdepth 1 -type d | while read dir; do
  find "$dir" -maxdepth 1 -type f -name 'recovery.img'
done >> filelist.txt

# Remove the leading SOURCE_DIR path from each entry
sed -i "s|^$SOURCE_DIR||" filelist.txt

# Sync the listed recovery.img files while preserving the directory structure
rsync -av --files-from=filelist.txt --relative "$SOURCE_DIR" "$DEST_DIR"

# Check if rsync succeeded
if [ $? -ne 0 ]; then
  echo "Error: rsync failed."
  exit 1
fi

# Rename files in the destination folder
while read file; do
  # Determine the full path for the destination file
  dest_file="$DEST_DIR/$file"
  
  # Skip if the file does not exist
  if [ ! -f "$dest_file" ]; then
    echo "Warning: File not found - $dest_file"
    continue
  fi

  # Determine the new name and move the file
  dir=$(dirname "$file")
  base=$(basename "$file")
  newname="${dir##*/}_recovery.img" # Extract the top-level directory name
  new_path="$DEST_DIR/$dir/$newname"

  # Create the directory if it does not exist
  mkdir -p "$(dirname "$new_path")"

  mv "$dest_file" "$new_path"
done < filelist.txt

# Check if renaming succeeded
if [ $? -ne 0 ]; then
  echo "Error: Renaming failed."
  exit 1
fi

# Cleanup
rm filelist.txt






#out/target/product/*/recovery.img out/target/product/*/*.json out/target/product/*/changelog_*.txt 
#mv h870/recovery.img h870/recoveryh870.img

#mv us997/recovery.img us997/recoveryus997.img

# mkdir -p temp
# mv h870/*.json h872/*.json us997/*.json ./temp

# rm -rf android_vendor_crDroidOTA
# git clone https://$GH_TOKEN@github.com/xc112lg/android_vendor_crDroidOTA
# cp -n android_vendor_crDroidOTA/h872.json temp/h8721.json
# cp -n android_vendor_crDroidOTA/h870.json temp/h8701.json
# cp -n android_vendor_crDroidOTA/us997.json temp/us9971.json

# cd temp
# sed -n '/"response": \[/,/\]/p' h872.json | sed '1d;$d' > output.json;sed -e '/"response": \[/{r output.json' -e 'a,' -e '}' h8721.json > temp.json && mv temp.json h8721.json
# sed -n '/"response": \[/,/\]/p' h870.json | sed '1d;$d' > output.json;sed -e '/"response": \[/{r output.json' -e 'a,' -e '}' h8701.json > temp.json && mv temp.json h8701.json
# sed -n '/"response": \[/,/\]/p' us997.json | sed '1d;$d' > output.json;sed -e '/"response": \[/{r output.json' -e 'a,' -e '}' us9971.json > temp.json && mv temp.json us9971.json
# cd ..
# mv temp/h8721.json ./android_vendor_crDroidOTA/h872.json
# mv temp/h8701.json ./android_vendor_crDroidOTA/h870.json
# mv temp/us9971.json ./android_vendor_crDroidOTA/us997.json
# cd android_vendor_crDroidOTA
# git add .
# git commit -m "update"
# git push 
# cd ..
if [ -z "$(find "$source_folder" -type f \( -name "*.zip" -o -name "*.img" \))" ]; then
    echo "No .zip or .img files found in $source_folder or its subdirectories. Exiting."
    exit 1
fi

#rm -rf h870/*eng* h872/*eng* us997/*eng* 
#rm -rf h870/*ota* h872/*ota* us997/*ota* 


#export GH_TOKEN=$(cat gh_token.txt)
gh auth login --with-token $GH_TOKEN
#rm -rf Evolution-X
#git clone https://$GH_TOKENgithub.com/xc112lg/Evolution-X
mv h870/* h872/* us997/* ./Evolution-X/ 
cd Evolution-X
chmod u+x multi_upload.sh
. multi_upload.sh
