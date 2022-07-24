#!/bin/bash
trap "set +x; sleep 5; set -x" DEBUG
csvstack 2019-Nov-sample.csv 2019-Oct-sample.csv > 2019-sample-0.csv | 
csvcut -c event_time,event_type,product_id,category_id,brand,price,category_code,category_code 2019-sample-0.csv > 2019-sample-1.csv | 
csvgrep -c event_type -m purchase 2019-sample-1.csv > 2019-sample-2.csv | 
sed -i '1s/.*/event_time,event_type,product_id,category_id,brand,price,category,product_name/' 2019-sample-2.csv | 
sed -i -E 's/[\sUTC]//' 2019-sample-2.csv | 
sed -i -E 's/[.][a-zA-Z_]+[.][a-zA-Z_]+,[a-zA-Z_]+.[a-zA-Z_]+.|[.][a-zA-Z_]+,[a-zA-Z_]+./,/' 2019-sample-2.csv | 
csvlook 2019-sample-2.csv | head |
cat 2019-sample-2.csv | grep electronics | grep smartphone | awk -F ',' '{print $5}' | sort | uniq -c | sort -nr
