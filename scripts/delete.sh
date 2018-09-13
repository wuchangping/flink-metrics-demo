#!/usr/bin/env bash


delete-tickcluster () {
  gcloud container clusters delete $TICKCLUSTER --zone=$ZONE
}

delete-tigcluster () {
  gcloud container clusters delete $TIGCLUSTER --zone=$ZONE
}


delete-tickdisks () {
  echo "Deleting disks for tick..."
  gcloud compute disks delete chronograf kapacitor influxdb --zone=$ZONE
  gcloud compute disks delete influxdb-data grafana-data --zone=$ZONE
}

delete-tigdisks () {
  gcloud compute disks delete influxdb-data --zone=$ZONE
  gcloud compute disks delete grafana-data --zone=$ZONE
}

delete-namespace () {
  kubectl delete ns flink
}


delete-usage () {
  cat <<-HERE
  $0 delete
  - delete has the following subcommands
  
    - deletes the gcloud persistent disks for this application
    $ $0 delete tigdisks | tickdisks
      
    - deletes the gcloud cluster for this application
    $ $0 delete tigcluster | tickcluster
      
    - deletes the namespace and any other kube based resources for this application
    $ $0 delete tick | tig | flink | ns
    
HERE
}

delete () {
  case $1 in
    flink)
    flink-standalone)
    tick)
    tig)
	ns)
      delete-namespace
      ;;
	tickcluster)
      delete-tigcluster
      ;;
    tigcluster)
      delete-tigcluster
      ;;
    tickdisks)
      delete-tickdisks
      ;;
	tigdisks)
      delete-tigdisks
      ;;
    *)
      echo "USAGE: $0 $1"
      delete-usage
      exit 1
      ;;
  esac
}
