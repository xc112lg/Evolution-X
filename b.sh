#!/bin/bash
source_folder="."
rm -rf h870/* h872/* us997/* 
rm Evolution-X/*.zip
rm Evolution-X/*.img
rm Evolution-X/*.txt
#crave ssh -- ls
sudo apt-get install xz-utils

rsync -av --include='*/' --include='*.zip' --exclude='*' out/target/product/ ./


find out/target/product/*/ -name "system.img" | while read recovery; do
    folder_name=$(basename $(dirname "$recovery"))
    destination_dir=$(basename $(dirname "$recovery"))
    mkdir -p "$destination_dir"
    rsync -av "$recovery" "$destination_dir/recovery${folder_name}.img"
done



if [ -z "$(find "$source_folder" -type f \( -name "*.zip" -o -name "*.img" \))" ]; then
    echo "No .zip or .img files found in $source_folder or its subdirectories. Exiting."
    exit 1
fi

#rm -rf h870/*eng* h872/*eng* us997/*eng* 
rm -rf h870/*ota* h872/*ota* us997/*ota* 


export GH_TOKEN=$(cat gh_token.txt)
gh auth login --with-token $GH_TOKEN

cd tdgsi_a64_ab
xz -z system.img
cd -

#rm -rf Evolution-X
#git clone https://$GH_TOKENgithub.com/xc112lg/Evolution-X
mv tdgsi_a64_ab/* ./Evolution-X/ 
cd Evolution-X
chmod u+x multi_upload.sh
. multi_upload.sh
