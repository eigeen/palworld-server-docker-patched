#!/bin/bash

# get metadata
version_data=$(curl -s https://os3.eigeen.com/public-tmp/palworld-server-patch/version.json)
patch_info=$(echo "$version_data" | jq -c '.patch_files[]')

# get currrent md5
curr_md5=$(md5sum '/palworld/Pal/Binaries/Linux/PalServer-Linux-Test' | awk '{print $1}')

found=false
for row in $patch_info; do
    orig_md5=$(echo "$row" | jq -r '.orig_md5')
    patched_md5=$(echo "$row" | jq -r '.patched_md5')
    url=$(echo "$row" | jq -r '.url')

    if [ "$curr_md5" == "$orig_md5" ]; then
        found=true
        mv /palworld/Pal/Binaries/Linux/PalServer-Linux-Test /palworld/Pal/Binaries/Linux/PalServer-Linux-Test.orig
        curl -sL $url --output PalServer-Linux-Patch
        bspatch /palworld/Pal/Binaries/Linux/PalServer-Linux-Test.orig \
            /palworld/Pal/Binaries/Linux/PalServer-Linux-Test \
            PalServer-Linux-Patch

        new_md5=$(md5sum /palworld/Pal/Binaries/Linux/PalServer-Linux-Test | awk '{print $1}')

        if [ "$new_md5" != "$patched_md5" ]; then
            echo "Error: Patched file MD5 does not match expected value."
            exit 1
        fi

        echo "Patch applied successfully."
        break
    fi
done

if [ $found = false ]; then
    echo "Warn: No matching version found for current file MD5: ${curr_md5}, using the original file."
fi

chmod +x /palworld/Pal/Binaries/Linux/PalServer-Linux-Test