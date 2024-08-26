#!/bin/bash
source_folder="."
rm -rf h870/* h872/* us997/* 
rm Evolution-X/*.zip
rm Evolution-X/*.img
rm Evolution-X/*.txt
#crave ssh -- ls

rsync -av --include='*/' --include='*.zip' --exclude='*' out/target/product/ ./


find out/target/product/*/ -name "recovery.img" | while read recovery; do
    folder_name=$(basename $(dirname "$recovery"))
    destination_dir=$(basename $(dirname "$recovery"))
    mkdir -p "$destination_dir"
    rsync -av "$recovery" "$destination_dir/recovery${folder_name}.img"
done

cp out/target/product/h872/lineage-21.0-20240826-UNOFFICIAL-h872.zip lineage-21.0-20240826-UNOFFICIAL-h872.zip


ls

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


export GH_TOKEN=$(cat gh_token.txt)
gh auth login --with-token $GH_TOKEN
#rm -rf Evolution-X
#git clone https://$GH_TOKENgithub.com/xc112lg/Evolution-X
mv h870/* h872/* us997/* ./Evolution-X/ 
cd Evolution-X
chmod u+x multi_upload.sh
. multi_upload.sh
