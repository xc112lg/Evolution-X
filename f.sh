#!/bin/bash

#rm -rf h870/* h872/* us997/* 

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









#crave ssh -- ls





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

source_folder="."



specific_folders=("h870" "h872" "us997")

# Check for .zip or .img files in the specific subdirectories
found_files=0
for folder in "${specific_folders[@]}"; do
    if [ -d "$folder" ]; then
        if find "$folder" -type f \( -name "*.zip" -o -name "*.img" \) | grep -q .; then
            found_files=1
            break
        fi
    fi
done

if [ $found_files -eq 0 ]; then
    echo "No .zip or .img files found in specified folders (${specific_folders[*]}). Exiting."
    exit 1
fi

echo "Files found in specified folders."


#rm -rf h870/*eng* h872/*eng* us997/*eng* 
#rm -rf h870/*ota* h872/*ota* us997/*ota* 


export GH_TOKEN=$(cat gh_token.txt)
Check if user is already authenticated
if ! gh auth status &> /dev/null; then
    # User not authenticated, perform login
    gh auth login --with-token $GH_TOKEN
else
    echo "Already authenticated with GitHub."
fi



#rm -rf Evolution-X
#git clone https://$GH_TOKENgithub.com/xc112lg/Evolution-X
mv h870/* h872/* us997/* ./Evolution-X/ 


cd Evolution-X

chmod u+x multi_upload.sh
. multi_upload.sh
