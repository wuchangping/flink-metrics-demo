#/bin/sh

docker run --name flink_local --net host -p 8081:8081 -t wuchangping/flink:1.6.0 local

