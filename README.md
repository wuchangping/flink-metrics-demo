
### Forked from:
https://github.com/foxutech/TIG-on-Kubernetes
https://github.com/jackzampolin/tick-kube


# flink-metrics-demo

A tool to deploy flink on google Container engine and extract flink metrics 
into InfluxData's TICK stack and TIG(Telegraf InfluxDB grafana) stack.


### Requirements

- [Google Cloud SDK](https://cloud.google.com/sdk/docs/quickstarts)
  * Follow the instructions in the above article.
- [`kubectl`](https://cloud.google.com/sdk/docs/managing-components) installed
  * Once you have configured `gcloud`, run `gcloud components install kubectl`


### To Deploy:

##### Create a TICK stack

To create a flink and TICK cluster and return the IP where chronograf is running:

```bash
$ ./demo tick start
```

This command is a shortcut that runs following commands in order:


Once the `EXTERNAL-IP` is visible visit it in your web browser. The URLs for configuring Influx and Kapacitor from Chronograf are as follows:

```
InfluxDB: http://influxdb.flink:8086
Kapacitor: http://kapacitor.flink:8086
Ddefault database: telegraf
```

##### Create a TIG stack

To create a flink and TIG cluster and return the IP where grafana is running:

```bash
$ ./demo tig start
```


### Tearing Down


##### Full cluster teardown

To destroy all resources created by this demo run:

##### Destroy a TICK stack

```bash
$ ./demo tick shutdown
```
##### Destroy a TICK stack

```bash
$ ./demo tig shutdown
```


This command takes a few minutes and will require user input at 2 different places. 

