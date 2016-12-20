#!/bin/bash

filename=$(basename "$0")
if [ ! -f ../$filename ]; then
    echo "I expect to run in a folder below"
    exit 1
fi
rm -f urls.md *.txt

# Carlos said we should only focus on avg, sum, min and max

ORD=7e91c30d-5dd3-44cd-9f5b-fb4dd260defe./Drivers/NiagaraNetwork/dmcSgh/points/BldgMeter/kW_PredNormDegDay

read -r -d '' curlurls << EndOfMessage
http://localhost:4242/api/aggregators
http://localhost:4242/api/suggest?type=metrics&max=10000000
http://localhost:4242/api/query?start=1432094400000&m=sum:$ORD
http://localhost:4242/api/query?start=1432094400000&ms=true&m=sum:$ORD
http://localhost:4242/api/query?start=1432094401000&m=sum:$ORD
http://localhost:4242/api/query?start=1432094401000&ms=true&m=sum:$ORD
http://localhost:4242/api/query?start=1432094400000&end=1475812800000&m=sum:1d-avg:$ORD
http://localhost:4242/api/query?start=1432094400000&end=1475812800000&m=sum:1w-avg:$ORD
http://localhost:4242/api/query?start=1432094400000&end=1475812800000&m=sum:1n-avg:$ORD
http://localhost:4242/api/query?start=1432094400000&end=1475812800000&m=sum:1y-avg:$ORD
http://localhost:4242/api/query?start=1432094400000&end=1475812800000&m=sum:2d-min:$ORD
http://localhost:4242/api/query?start=1432094400000&end=1475812800000&m=sum:2w-min:$ORD
http://localhost:4242/api/query?start=1432094400000&end=1475812800000&m=sum:2n-max:$ORD
http://localhost:4242/api/query?start=1432094400000&end=1475812800000&m=sum:2y-max:$ORD
http://localhost:4242/api/query?start=1432094400000&end=1475812800000&m=sum:3d-sum:$ORD
http://localhost:4242/api/query?start=1432094400000&end=1475812800000&m=sum:3w-sum:$ORD
http://localhost:4242/api/query?start=1432094400000&end=1475812800000&m=sum:3n-sum:$ORD
http://localhost:4242/api/query?start=1432094400000&end=1475812800000&m=sum:3y-sum:$ORD
http://localhost:4242/api/query?start=1432094401000&end=1475812799000&m=sum:1d-min:$ORD
http://localhost:4242/api/query?start=1432094401000&end=1475812799000&m=sum:1w-min:$ORD
http://localhost:4242/api/query?start=1432094401000&end=1475812799000&m=sum:1n-max:$ORD
http://localhost:4242/api/query?start=1432094401000&end=1475812799000&m=sum:1y-max:$ORD
http://localhost:4242/api/query?start=1432094400000&end=1475812800000&m=sum:1d-avg:$ORD&tz=Europe/London&use_calendar=true
http://localhost:4242/api/query?start=1432094400000&end=1475812800000&m=sum:1w-avg:$ORD&tz=America/Detroit&use_calendar=true
http://localhost:4242/api/query?start=1432094400000&end=1475812800000&m=sum:1w-avg:$ORD&tz=America/Detroit&use_calendar=false
http://localhost:4242/api/query?start=1432094400000&end=1475812800000&m=sum:1w-avg:$ORD&tz=US/Eastern&use_calendar=true
http://localhost:4242/api/query?start=1432094400000&end=1475812800000&m=sum:1w-avg:$ORD&tz=US/Pacific&use_calendar=true
http://localhost:4242/api/query?start=1432094400000&end=1475812800000&m=sum:1w-avg:$ORD&tz=US/Mountain&use_calendar=true
http://localhost:4242/api/query?start=1432094400000&end=1475812800000&m=sum:1w-avg:$ORD&tz=US/Central&use_calendar=true
http://localhost:4242/api/query?start=1432094400000&end=1475812800000&m=sum:1n-avg:$ORD&tz=US/Michigan&use_calendar=true
http://localhost:4242/api/query?start=1432094400000&end=1475812800000&m=sum:1y-avg:$ORD&tz=US/Arizona&use_calendar=true
EndOfMessage

counter=1
rm -f urls.md
for each in $curlurls
do
    echo 1. $each >> urls.md
    printf -v counterstr "%02d" $counter
    echo $counterstr: $each
    echo $each > $counterstr.txt
    curl -s "$each" | python -m json.tool >> $counterstr.txt
    ((counter++))
done

echo "

Please run the following commands to Delete 5/24 6/24 7/24 8/24 9/24

    cd /opt/opentsdb/opentsdb-2.1.3.5/bin
    ./tsdb scan --delete 2016/05/24 2016/05/25 sum $ORD
    ./tsdb scan --delete 2016/06/24 2016/06/25 sum $ORD
    ./tsdb scan --delete 2016/07/24 2016/07/25 sum $ORD
    ./tsdb scan --delete 2016/08/24 2016/08/25 sum $ORD
    ./tsdb scan --delete 2016/09/24 2016/09/25 sum $ORD
    rm /tmp/*
"
read -n1 -r -p "Press a key to continue..." anykey

echo "Dropping memory cache and sleep 20 seconds"
curl http://localhost:4242/api/dropcaches
sleep 20

for each in $curlurls
do
    echo 1. $each >> urls.md
    printf -v counterstr "%02d" $counter
    echo $counterstr: $each
    echo $each > $counterstr.txt
    curl -s "$each" | python -m json.tool >> $counterstr.txt
    ((counter++))
done

echo "

Inserting data into TSDB

"
curl -X POST --data-binary "@../testput.json" --header "Content-Type: application/json" http://localhost:4242/api/put?details

echo "Dropping memory cache and sleep 20 seconds"
curl http://localhost:4242/api/dropcaches
sleep 20

for each in $curlurls
do
    echo 1. $each >> urls.md
    printf -v counterstr "%02d" $counter
    echo $counterstr: $each
    echo $each > $counterstr.txt
    curl -s "$each" | python -m json.tool >> $counterstr.txt
    ((counter++))
done
