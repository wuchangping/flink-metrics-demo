#!/usr/bin/env bash

tick-deploy () {
  case $1 in 
    start)
      config set
      sleep 1
      create tickcluster
      sleep 2
      create tickdisks
      sleep 2
      create namespace
      create tick
      sleep 2
      #create flink
      exit 0
      ;;
    destroy)
      delete ns
      delete tickcluster
      delete tickdisks
      exit 0
      ;;
    *)
      echo "USAGE: $0 $1"
      tick-deploy-usage
      exit 1
      ;;
  esac
}

tick-deploy-usage () {
  cat <<-HERE
  $0 tick
  - deploy has the following subcommands
  
    - deploy start a new cluster w/ all resources and provisions the full tick stack
    $ $0 tick start

    - deletes the cluster and all associated resources
    $ $0 tick destroy
    
HERE
}
