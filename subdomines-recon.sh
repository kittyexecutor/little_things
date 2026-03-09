#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Using: $0 <TARGET> [DIRECTORY]"
    exit 1
fi

TARGET=$1
DIR=${2:-.}  # default dir
#API_KEY="Your key for DNS booster"

# Create a catalog if no exist
mkdir -p "$DIR"

echo "Start recon for $TARGET in $DIR..."

# 1. Searching by crt.sh
curl -s "https://crt.sh/?q=${TARGET}&output=json" | jq -r '.[].name_value' | sort -u > "${DIR}/${TARGET}.txt"
sed -i 's/common_name//g; s/[":,]//g; s/ //g' "${DIR}/${TARGET}.txt"

# 2. Assetfinder
assetfinder --subs-only "${TARGET}" >> "${DIR}/af-${TARGET}.txt"

# 2.1 DNSdumpster echo (the URL "${DIR}/dd-${TARGET}" need to be added to 34th line if DNSBuster using)
#echo "DNSdumpster via API"; curl -s -H "X-API-Key: $API_KEY" "https://api.dnsdumpster.com/domain/${TARGET}" | sort -u | grep host | awk -F'"host": "' '{print $2}' | awk -F'",' '{print $1}' > "${DIR}/dd-${TARGET}"

# 2.2 Fuzzing by Gobuster
echo "Gobuster DNS"; \
gobuster dns -do ${TARGET} -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt -o "${DIR}/gb-${TARGET}" --wildcard
sed -i 's/ .*//' ${DIR}/gb-${TARGET}
mv ${DIR}/gb-${TARGET} ${DIR}/gb-${TARGET}.txt

# 3. Concatination and geting unique values
cat "${DIR}/u-${TARGET}.txt" "${DIR}/af-${TARGET}.txt" "${DIR}/gb-${TARGET}.txt" | sort -u > "${DIR}/all-${TARGET}.txt"

# 4. httpx
httpx -status-code -tech-detect -l "${DIR}/all-${TARGET}.txt" -o "${DIR}/hx-${TARGET}.txt"

# 5. clean and text normalization
grep -v "\[404\]" "${DIR}/hx-${TARGET}.txt" | \
sed -E 's|https?://||g; s|[[:space:]].*||g' | \
sort -u > "${DIR}/hxc-${TARGET}.txt"

# 6. Sort
sort "${DIR}/hxc-${TARGET}.txt" > "${DIR}/hxc-${TARGET}.tmp" && \
mv "${DIR}/hxc-${TARGET}.tmp" "${DIR}/hxc-${TARGET}.txt"

# Remuving garbege
rm -f "${DIR}/${TARGET}.txt"*.json "${DIR}/af-${TARGET}.txt" "${DIR}/u-${TARGET}.txt"

echo "✅ Complete"
echo "📊 Live domines (!404): $(wc -l < "${DIR}/hxc-${TARGET}.txt")"