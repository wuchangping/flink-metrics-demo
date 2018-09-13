#!/usr/bin/env bash

kube () {
  kubectl apply -f $1
}

##
##*************** TICK stack ******************
##

create-namespace () {
  echo "Creating namespace..."
  kube $BP/namespace.yaml
}

create-tickcluster () {
  echo "Creating a $NUM_NODES node cluster of $MACHINE VMs with $DISK GB size disks."
  gcloud container clusters create --disk-size $DISK --machine-type $MACHINE --num-nodes $NUM_NODES $TICKCLUSTER 
  gcloud container clusters get-credentials $TICKCLUSTER
}

create-tickdisks () {
  echo "Creating persistent disks for the tick stack..."
  echo "InfluxDB Disk: $INFLUX_DISK"
  echo "Kapacitor Disk: $OTHER_DISK"
  echo "chronograf Disk: $OTHER_DISK"
  gcloud compute disks create chronograf kapacitor --size=$OTHER_DISK
  gcloud compute disks create influxdb --size=$INFLUX_DISK
}


create-tick () {
  echo "Creating tick stack..."
  echo "tick is the full stack of InfluxData products running in production configuration"
  kubectl create configmap --namespace flink telegraf-config --from-file $BP/tick/telegraf/telegraf.conf
  kubectl create configmap --namespace flink influxdb-config --from-file $BP/tick/influxdb/influxdb.conf
  kube $BP/tick/influxdb/deployment.yaml
  kube $BP/tick/influxdb/service.yaml
  kube $BP/tick/kapacitor/deployment.yaml
  kube $BP/tick/kapacitor/service.yaml
  kube $BP/tick/telegraf/daemonset.yaml
  kube $BP/tick/chronograf/deployment.yaml
  kube $BP/tick/chronograf/service.yaml
  echo "Waiting for public IP..."
  echo "kubectl get svc --namespace flink "
  kubectl get svc --namespace flink  
}


##
##*************** TIG stack ******************
##

create-tigcluster () {
  echo "Creating a $NUM_NODES node cluster of $MACHINE VMs with $DISK GB size disks."
  gcloud container clusters create --disk-size $DISK --machine-type $MACHINE --num-nodes $NUM_NODES $TIGCLUSTER 
  gcloud container clusters get-credentials $TIGCLUSTER
}

create-tigdisks () {
  echo "Creating persistent disks for the tig stack..."
  echo "InfluxDB Disk: $INFLUX_DISK"
  echo "Grafana Disk: $OTHER_DISK"
  gcloud compute disks create grafana-data --size=$OTHER_DISK
  gcloud compute disks create influxdb-data --size=$INFLUX_DISK
}

create-tig () {
  echo "Creating tig stack..."
  kube $BP/tig/influxdb/influxdb-service.yaml
  kube $BP/tig/influxdb/influxdb-deployment.yaml
  kube $BP/tig/grafana/grafana-service.yaml
  kube $BP/tig/grafana/grafana-deployment.yaml
  kubectl create configmap --namespace flink telegraf-config --from-file $BP/tig/telegraf/telegraf.conf
  kube $BP/tig/telegraf/telegraf.yaml

  echo "Waiting for public IP..."
  echo "kubectl get svc --namespace flink  "
  kubectl get svc --namespace flink
}

##
##*************** Flink ******************
##

create-flink () {
  echo "Creating flink..."
  kube $BP/flink/flink/jobmanager-deployment.yaml
  kube $BP/flink/flink/jobmanager-service.yaml
  kube $BP/flink/flink/jobmanager-webui-service.yaml
  kube $BP/flink/flink/taskmanager-deployment.yaml
  
  echo "kubectl get svc --namespace flink  "
  kubectl get svc --namespace flink  
}

create-flink-standalone () {
  echo "Creating flink standalone..."
  kube $BP/flink/flink-standalone/service.yaml
  kube $BP/flink/flink-standalone/deployment.yaml
  
  echo "kubectl get svc --namespace flink  "
  kubectl get svc --namespace flink  
}

create-flink-bak () {
  echo "Creating flink.bak..."
  kube $BP/flink/flink.bak/flink-service.yaml
  kube $BP/flink/flink.bak/jobmanager-deployment.yaml
  kube $BP/flink/flink.bak/taskmanager-deployment.yaml

  echo "kubectl get svc --namespace flink  "
  kubectl get svc --namespace flink  
}




create-usage () {
  cat <<-HERE 
  $0 create
  - create has the following subcommands
    - creates namespace to run this example
    $ $0 create namespace
  
    - creates cluster to run this example
    $ $0 create tigcluster | tickcluster
    
    - creates all gcloud persistent disks for this application 
    $ $0 create tigdisks | tickcluster
  
    - creates all kube based resources for this application 
    $ $0 create tick
  
    - creates all kube based resources for this application 
    $ $0 create flink

    - creates all kube based resources for this application 
    $ $0 create flink-standalone
    
HERE
}

create () {
  case $1 in
    namespace)
      create-namespace 
      ;;
    flink)
      create-flink
      ;;
    flink-standalone)
      create-flink-standalone
      ;;
	flink-bak)
      create-flink-bak
      ;;
    tick)
      create-tick
      ;;
    tig)
      create-tig
      ;;
    tickcluster)
      create-tickcluster
      ;;
	tigcluster)
      create-tigcluster
      ;;
    tickdisks)
      create-tickdisks
      ;;
    tigdisks)
      create-tigdisks
      ;;
    *)
      echo "USAGE: $0 $1"
      create-usage
      exit 1
      ;;
  esac
}

