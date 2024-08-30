#!/bin/bash
source_folder="."
rm -rf h870/* h872/* us997/* 
rm Evolution-X/*.zip
rm Evolution-X/*.img
rm Evolution-X/*.txt
#crave ssh -- ls
sudo apt-get install xz-utils -y

# rsync -av --include='*/' --include='*.zip' --exclude='*' out/target/product/ ./


# find out/target/product/*/ -name "system.img" | while read recovery; do
#     folder_name=$(basename $(dirname "$recovery"))
#     destination_dir=$(basename $(dirname "$recovery"))
#     mkdir -p "$destination_dir"
#     rsync -av "$recovery" "$destination_dir/recovery${folder_name}.img"
# done
mkdir -p phhgsi_arm64_ab
cp out/target/product/phhgsi_arm64_ab/system.img phhgsi_arm64_ab

if [ -z "$(find phhgsi_arm64_ab -type f \( -name "*.zip" -o -name "*.img" \))" ]; then
    echo "No .zip or .img files found in $source_folder or its subdirectories. Exiting."
    exit 1
fi

#rm -rf h870/*eng* h872/*eng* us997/*eng* 
rm -rf h870/*ota* h872/*ota* us997/*ota* 


export GH_TOKEN=$(cat gh_token.txt)
gh auth login --with-token $GH_TOKEN

cd phhgsi_arm64_ab/
xz -z system.img
rm system.img
cd -

#rm -rf Evolution-X
#git clone https://$GH_TOKENgithub.com/xc112lg/Evolution-X
mv phhgsi_arm64_ab/* ./Evolution-X/ 
cd Evolution-X
chmod u+x multi_upload.sh
. multi_upload.sh
