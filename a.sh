#!/bin/bash
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


# Find recovery.img files at the top level of out/target/product/
find out/target/product/ -maxdepth 1 -type f -name 'recovery.img' > filelist.txt

# Find recovery.img files in subdirectories one level deep
find out/target/product/ -mindepth 1 -maxdepth 1 -type d | while read dir; do
  find "$dir" -maxdepth 1 -type f -name 'recovery.img'
done >> filelist.txt

# Remove the leading out/target/product/ path from each entry
sed -i 's|^out/target/product/||' filelist.txt

# Sync the listed recovery.img files while preserving the directory structure
rsync -av --files-from=filelist.txt --relative out/target/product/ ./

# Rename each recovery.img file to include its folder name
while IFS= read -r file; do
  # Extract the folder name from the file path
  foldername=$(dirname "$file")
  filename=$(basename "$file")

  # If the file is at the top level, use "top_level" as the folder name
  if [ "$foldername" = "." ]; then
    new_name="top_level_$filename"
  else
    new_name="${foldername}_$filename"
  fi

  # Rename the recovery.img file to foldername_recovery.img
  mv "$file" "${foldername}/${new_name}"
done < filelist.txt




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
