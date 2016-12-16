
## Build

Environment set up:

	sudo apt-get install oracle-java8-installer
	sudo apt-get install autoconf

Build Jar:

	./build.sh

Build Debian package:

	./build.sh debian

Clean (for rebuild)

	./build.sh clean


## 2.1.3.6 docker

Add the following lines to opentsdb.conf

	# 2.1.3 only, and 2.1.3.6+ only
	tsd.query.timeout = 30000

Start docker

	docker run -d -p 4242:4242 -v /tmp/data/hbase/hbaseroot/hbase:/data/hbase/hbaseroot/hbase -h localhost --name tsdb213b resolutetsdb
	docker stop tsdb213b
	docker cp ~/VMs/tsdbbuild/opentsdb213/build/tsdb-2.1.3.6.jar tsdb213b:/opt/opentsdb/opentsdb-2.1.3.5/lib/tsdb-2.1.3.5.jar
	docker cp ~/VMs/tsdbbuild/opentsdb213/build/third_party/hbase/asynchbase-1.7.2.jar tsdb213b:/opt/opentsdb/opentsdb-2.1.3.5/lib/asynchbase-1.6.0.jar
	docker cp ~/VMs/tsdbbuild/opentsdb213/docs/NF-1678/opentsdb.conf tsdb213b:/opt/opentsdb/opentsdb-2.1.3.5/conf/opentsdb.conf
	docker start tsdb213b
	
	docker exec -it tsdb213b bash

	docker restart tsdb213b

## IDE

	http://opentsdb.net/docs/build/html/development/development.html

## Demo of problem is solved

	curl "http://localhost:4242/api/query?start=1432094401000&end=1475812799000&m=sum:1y-max:7e91c30d-5dd3-44cd-9f5b-fb4dd260defe./Drivers/NiagaraNetwork/dmcSgh/points/BldgMeter/kW_PredNormDegDay"
	/opt/hbase/bin/hbase regionserver start

