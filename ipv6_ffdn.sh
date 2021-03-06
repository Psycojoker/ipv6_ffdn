#!/bin/bash

set -eux

FAI_SITE=`curl -s https://db.ffdn.org/api/v1/isp/?per_page=9999 |jq '.isps[] | select(.is_ffdn_member == true) | .ispformat.name + "|"+ .ispformat.website' | tr -d '"'`

while FAI= read -r i; do
echo "========================================================================================================"
echo $i |awk -F '|' '{print $1}'
site=`echo $i |awk -F '|' '{print $2}'| tr -d '"' |sed 's/http[s]*:\/\///;s/\///'`
site2=`echo $site | sed 's/www.//'`
echo "========================================================"
echo " WWW IPv6"
echo " ========"
if [ -n "$site" ]; then
echo $site
dig AAAA $site +short
echo "------------------------------------------------------"
echo " MX IPv6" 
echo " ======="
MAIL=`dig MX $site2 +short| awk -F ' ' '{print $2}' |sed 's/.$//'`
if [ -n "$MAIL" ]; then
echo "$MAIL" | while read n; do
echo "url: $n"
mx=`dig AAAA $n +short`
if [[ "$mx" =~ ^((([0-9A-Fa-f]{1,4}:){7}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){6}:[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){5}:([0-9A-Fa-f]{1,4}:)?[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){4}:([0-9A-Fa-f]{1,4}:){0,2}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){3}:([0-9A-Fa-f]{1,4}:){0,3}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){2}:([0-9A-Fa-f]{1,4}:){0,4}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){6}((b((25[0-5])|(1d{2})|(2[0-4]d)|(d{1,2}))b).){3}(b((25[0-5])|(1d{2})|(2[0-4]d)|(d{1,2}))b))|(([0-9A-Fa-f]{1,4}:){0,5}:((b((25[0-5])|(1d{2})|(2[0-4]d)|(d{1,2}))b).){3}(b((25[0-5])|(1d{2})|(2[0-4]d)|(d{1,2}))b))|(::([0-9A-Fa-f]{1,4}:){0,5}((b((25[0-5])|(1d{2})|(2[0-4]d)|(d{1,2}))b).){3}(b((25[0-5])|(1d{2})|(2[0-4]d)|(d{1,2}))b))|([0-9A-Fa-f]{1,4}::([0-9A-Fa-f]{1,4}:){0,5}[0-9A-Fa-f]{1,4})|(::([0-9A-Fa-f]{1,4}:){0,6}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){1,7}:))$ ]]; then
    echo $mx
fi
done
else
echo "NO MX"
fi
else
echo "NO SITE"
fi
done < echo $FAI_SITE
