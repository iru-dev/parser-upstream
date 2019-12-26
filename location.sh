#!/bin/bash
cat /export/docs/locations-partners|grep -vE "(^#|^$|deny all|set $location|rewrite|proxy_cache|include|access_log|proxy_hide_header|proxy_intercept_errors|proxy_cache_valid|default_type|proxy_next)" > /tmp/lp2
sed -e 's/  location/location/g' /tmp/lp2 > /tmp/lp3
sed 's/^[ \t]*//;s/[ \t]*$//' /tmp/lp3 > /tmp/lp4
cat /tmp/lp4 |grep location -wc
cat /tmp/lp4 |  tr -s '\r\n' ' ' > /tmp/lp5
sed "s/; }/\n/g" /tmp/lp5 > /tmp/lp6
sed "s/{/|/g" /tmp/lp6 > /tmp/lp7


sed "s/https:/http:/g" /tmp/lp7 > /tmp/lp8
sed "s/allow/allow/g" /tmp/lp8 > /tmp/lp9

sed 's/^[ \t]*//;s/[ \t]*$//' /tmp/lp9 > /tmp/lp10
sed 's/proxy_pass/proxy_pass/g' /tmp/lp10 > /tmp/lp11


cat /export/docs/10-upstreams-prod.conf |grep -vE "(ip_hash|zone|least_conn|keepalive)" > /tmp/up0

sed 's/^[ \t]*//;s/[ \t]*$//' /tmp/up0 > /tmp/up1
sed 's/#.*$//g' /tmp/up1 > /tmp/up2
sed 's/^[ \t]*//;s/[ \t]*$//' /tmp/up2 > /tmp/up3
sed 's/  / /g' /tmp/up3 > /tmp/up4
sed 's/server consul service=/server /g' /tmp/up4 > /tmp/up5
sed 's/ max_fails=0//g;s/ max_fails=10//g;s/ fail_timeout=10//g' /tmp/up5 > /tmp/up6
sed 's/backup\;/\;/g' /tmp/up6 > /tmp/up7
sed 's/ fail_timeout=0//g' /tmp/up7 > /tmp/up8
sed 's/resolve//g' /tmp/up8 > /tmp/up9
sed 's/  / /g;s/  / /g;s/ \;/;/g' /tmp/up9 > /tmp/up10
cat /tmp/up10 |  tr -s '\r\n' ' ' > /tmp/up11
sed "s/upstream//g;s/; }/\n/g;s/{/|/g;s/ server //g;s/ |/|/g;s/ //g" /tmp/up11 > /tmp/up12


#cat /tmp/up11
php /export/docs/locations-partners.php /tmp/lp11 /tmp/up12 
rm -f /tmp/lp*
rm -f /tmp/up*
