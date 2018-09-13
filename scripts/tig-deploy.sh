#!/usr/bin/env bash

tig-deploy () {
  case $1 in 
    start)
      config set
      sleep 1
      create tigcluster
      sleep 2
      create tigdisks
      sleep 2
      create namespace
      create tig
      sleep 2
      create flink
      exit 0
      ;;
    destroy)
      delete ns
      delete tigcluster
      delete tigdisks
      exit 0
      ;;
    *)
      echo "USAGE: $0 $1"
      tig-deploy-usage
      exit 1
      ;;
  esac
}

tig-deploy-usage () {
  cat <<-HERE
  $0 tig
  - deploy has the following subcommands
  
    - deploy start a new cluster w/ all resources and provisions the full tick stack
    $ $0 tig start

    - deletes the cluster and all associated resources
    $ $0 tig destroy
    
HERE
}
