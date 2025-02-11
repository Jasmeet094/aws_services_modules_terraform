<p align="left"><img width=400 height="100" src="https://www.nclouds.com/img/nclouds-logo.svg"></p>  

![Terraform](https://github.com/nclouds/terraform-aws-datadog/workflows/Terraform/badge.svg)
# nCode Library

## Terraform Module for Datadog Monitors on AWS

Terraform module to provision [`Datadog Monitors`](https://app.datadoghq.com/) on AWS.

## Usage

### Simple setup

Create simple Datadog monitors with default configurations.
```hcl
    module "datadog" {
        source  = "git@github.com:nclouds/terraform-aws-datadog.git?ref=v0.1.9"
        system  = true
        lambda  = true
        k8s     = true
        ecs     = true
        rds     = true
        elb     = true
        alb     = true
        tags    = {
            Owner = "example@nclouds.com"
        }
    }

```

For more details on a working example, please visit [`examples/simple`](examples/simple)

### Advanced Setup
If you want to create Datadog monitors with custom configuration e.g custom metrics, custom tags for triggers, custom notification templates etc., you can use the module like this:

```hcl
    module "datadog" {
        source  = "git@github.com:nclouds/terraform-aws-datadog.git?ref=v0.1.9"
        system  = true
        elb     = true
        tags    = {
            Owner = "example@nclouds.com"
        }
        system_queries = {
            disk_total = "avg:system.disk.total"
            mem_total  = "avg:system.mem.total"
            disk_free  = "avg:system.disk.free"
            mem_used   = "avg:system.mem.used"
            load       = "avg:system.load.norm.5"
            cpu        = "avg:system.cpu.idle"
        }
        elb_queries = {
            surge_queue_length  = "avg:aws.elb.surge_queue_length"
            active_connection   = "avg:aws.elb.active_connection_count"
            unhealthy_host      = "avg:aws.elb.unhealthy_host_count"
            response_time       = "avg:aws.elb.target_response_time.average"
            request_count       = "avg:aws.elb.request_count"
            healthy_host        = "avg:aws.elb.healthy_host_count"
            spill_over          = "avg:aws.elb.spillover_count"
            count_4xx           = "avg:aws.elb.httpcode_elb_4xx"
            count_5xx           = "avg:aws.elb.httpcode_elb_5xx"
            latency             = "avg:aws.elb.latency"
        }
        system_trigger_by = "{host,Environment}"
        elb_trigger_by    = "{host,region,Environment}"
        elb_alert_message = <<EOF
        Value: {{value}}
        Name: {{host.name}}
        Region: {{region.name}}
        Environment: {{Environment.name}}

        {{#is_no_data}}Not receiving data @pagerduty{{/is_no_data}}
        {{#is_alert}}@pagerduty{{/is_alert}}
        {{#is_warning}}@pagerduty{{/is_warning}}
        {{#is_recovery}}@pagerduty{{/is_recovery}}
        @slack-alerts
        EOF

        system_alert_message = <<EOF
        Value: {{value}}
        Name: {{host.name}}
        Region: {{region.name}}
        Environment: {{Environment.name}}

        {{#is_no_data}}Not receiving data @pagerduty{{/is_no_data}}
        {{#is_alert}}@pagerduty{{/is_alert}}
        {{#is_warning}}@pagerduty{{/is_warning}}
        {{#is_recovery}}@pagerduty{{/is_recovery}}
        @slack-alerts
        EOF
    }
```

For more options refer to a working example at [`examples/advanced`](examples/advanced)

## Examples
Here are some working examples of using this module:
- [`examples/simple`](examples/simple)
- [`examples/advanced`](examples/advanced)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_active_connection"></a> [active\_connection](#module\_active\_connection) | ./modules/datadog-monitor | n/a |
| <a name="module_alb_4xx"></a> [alb\_4xx](#module\_alb\_4xx) | ./modules/datadog-monitor | n/a |
| <a name="module_alb_5xx"></a> [alb\_5xx](#module\_alb\_5xx) | ./modules/datadog-monitor | n/a |
| <a name="module_alb_active_connection"></a> [alb\_active\_connection](#module\_alb\_active\_connection) | ./modules/datadog-monitor | n/a |
| <a name="module_alb_healthy_host_count"></a> [alb\_healthy\_host\_count](#module\_alb\_healthy\_host\_count) | ./modules/datadog-monitor | n/a |
| <a name="module_alb_rejected"></a> [alb\_rejected](#module\_alb\_rejected) | ./modules/datadog-monitor | n/a |
| <a name="module_alb_request_count"></a> [alb\_request\_count](#module\_alb\_request\_count) | ./modules/datadog-monitor | n/a |
| <a name="module_alb_target_response_time"></a> [alb\_target\_response\_time](#module\_alb\_target\_response\_time) | ./modules/datadog-monitor | n/a |
| <a name="module_alb_unhealthy_host_count"></a> [alb\_unhealthy\_host\_count](#module\_alb\_unhealthy\_host\_count) | ./modules/datadog-monitor | n/a |
| <a name="module_cpu_utilization"></a> [cpu\_utilization](#module\_cpu\_utilization) | ./modules/datadog-monitor | n/a |
| <a name="module_crashloopbackoff"></a> [crashloopbackoff](#module\_crashloopbackoff) | ./modules/datadog-monitor | n/a |
| <a name="module_current_conn"></a> [current\_conn](#module\_current\_conn) | ./modules/datadog-monitor | n/a |
| <a name="module_diff_in_nodes_daemonset"></a> [diff\_in\_nodes\_daemonset](#module\_diff\_in\_nodes\_daemonset) | ./modules/datadog-monitor | n/a |
| <a name="module_diff_in_replica_replicaset"></a> [diff\_in\_replica\_replicaset](#module\_diff\_in\_replica\_replicaset) | ./modules/datadog-monitor | n/a |
| <a name="module_diff_in_replica_statefulset"></a> [diff\_in\_replica\_statefulset](#module\_diff\_in\_replica\_statefulset) | ./modules/datadog-monitor | n/a |
| <a name="module_diff_in_replicas_deployment"></a> [diff\_in\_replicas\_deployment](#module\_diff\_in\_replicas\_deployment) | ./modules/datadog-monitor | n/a |
| <a name="module_ec_failover"></a> [ec\_failover](#module\_ec\_failover) | ./modules/datadog-monitor | n/a |
| <a name="module_ecs_cluster_cpu_reservation"></a> [ecs\_cluster\_cpu\_reservation](#module\_ecs\_cluster\_cpu\_reservation) | ./modules/datadog-monitor | n/a |
| <a name="module_ecs_cluster_cpu_utilization"></a> [ecs\_cluster\_cpu\_utilization](#module\_ecs\_cluster\_cpu\_utilization) | ./modules/datadog-monitor | n/a |
| <a name="module_ecs_cluster_mem_reservation"></a> [ecs\_cluster\_mem\_reservation](#module\_ecs\_cluster\_mem\_reservation) | ./modules/datadog-monitor | n/a |
| <a name="module_ecs_cluster_mem_utilization"></a> [ecs\_cluster\_mem\_utilization](#module\_ecs\_cluster\_mem\_utilization) | ./modules/datadog-monitor | n/a |
| <a name="module_ecs_service_cpu_utilization"></a> [ecs\_service\_cpu\_utilization](#module\_ecs\_service\_cpu\_utilization) | ./modules/datadog-monitor | n/a |
| <a name="module_ecs_service_mem_utilization"></a> [ecs\_service\_mem\_utilization](#module\_ecs\_service\_mem\_utilization) | ./modules/datadog-monitor | n/a |
| <a name="module_ecs_task_count"></a> [ecs\_task\_count](#module\_ecs\_task\_count) | ./modules/datadog-monitor | n/a |
| <a name="module_elb_4xx"></a> [elb\_4xx](#module\_elb\_4xx) | ./modules/datadog-monitor | n/a |
| <a name="module_elb_5xx"></a> [elb\_5xx](#module\_elb\_5xx) | ./modules/datadog-monitor | n/a |
| <a name="module_elb_healthy_host_count"></a> [elb\_healthy\_host\_count](#module\_elb\_healthy\_host\_count) | ./modules/datadog-monitor | n/a |
| <a name="module_elb_latency"></a> [elb\_latency](#module\_elb\_latency) | ./modules/datadog-monitor | n/a |
| <a name="module_elb_request_count"></a> [elb\_request\_count](#module\_elb\_request\_count) | ./modules/datadog-monitor | n/a |
| <a name="module_elb_spillover"></a> [elb\_spillover](#module\_elb\_spillover) | ./modules/datadog-monitor | n/a |
| <a name="module_elb_surge_queue_length"></a> [elb\_surge\_queue\_length](#module\_elb\_surge\_queue\_length) | ./modules/datadog-monitor | n/a |
| <a name="module_elb_target_response_time"></a> [elb\_target\_response\_time](#module\_elb\_target\_response\_time) | ./modules/datadog-monitor | n/a |
| <a name="module_elb_unhealthy_host_count"></a> [elb\_unhealthy\_host\_count](#module\_elb\_unhealthy\_host\_count) | ./modules/datadog-monitor | n/a |
| <a name="module_engine_cpu_utilization"></a> [engine\_cpu\_utilization](#module\_engine\_cpu\_utilization) | ./modules/datadog-monitor | n/a |
| <a name="module_evictions"></a> [evictions](#module\_evictions) | ./modules/datadog-monitor | n/a |
| <a name="module_failover"></a> [failover](#module\_failover) | ./modules/datadog-monitor | n/a |
| <a name="module_host_mem"></a> [host\_mem](#module\_host\_mem) | ./modules/datadog-monitor | n/a |
| <a name="module_imagepull_backoff"></a> [imagepull\_backoff](#module\_imagepull\_backoff) | ./modules/datadog-monitor | n/a |
| <a name="module_job_failed"></a> [job\_failed](#module\_job\_failed) | ./modules/datadog-monitor | n/a |
| <a name="module_lag"></a> [lag](#module\_lag) | ./modules/datadog-monitor | n/a |
| <a name="module_lambda_concurrent_executions"></a> [lambda\_concurrent\_executions](#module\_lambda\_concurrent\_executions) | ./modules/datadog-monitor | n/a |
| <a name="module_lambda_duration"></a> [lambda\_duration](#module\_lambda\_duration) | ./modules/datadog-monitor | n/a |
| <a name="module_lambda_errors"></a> [lambda\_errors](#module\_lambda\_errors) | ./modules/datadog-monitor | n/a |
| <a name="module_lambda_throtttle_executions"></a> [lambda\_throtttle\_executions](#module\_lambda\_throtttle\_executions) | ./modules/datadog-monitor | n/a |
| <a name="module_memc_mem"></a> [memc\_mem](#module\_memc\_mem) | ./modules/datadog-monitor | n/a |
| <a name="module_node_disk_pressure"></a> [node\_disk\_pressure](#module\_node\_disk\_pressure) | ./modules/datadog-monitor | n/a |
| <a name="module_node_mem_pressure"></a> [node\_mem\_pressure](#module\_node\_mem\_pressure) | ./modules/datadog-monitor | n/a |
| <a name="module_node_nw_unavailable"></a> [node\_nw\_unavailable](#module\_node\_nw\_unavailable) | ./modules/datadog-monitor | n/a |
| <a name="module_node_out_of_disk"></a> [node\_out\_of\_disk](#module\_node\_out\_of\_disk) | ./modules/datadog-monitor | n/a |
| <a name="module_pod_memory"></a> [pod\_memory](#module\_pod\_memory) | ./modules/datadog-monitor | n/a |
| <a name="module_rds_burst_balance"></a> [rds\_burst\_balance](#module\_rds\_burst\_balance) | ./modules/datadog-monitor | n/a |
| <a name="module_rds_cpu_utilization"></a> [rds\_cpu\_utilization](#module\_rds\_cpu\_utilization) | ./modules/datadog-monitor | n/a |
| <a name="module_rds_cpucredit_balance"></a> [rds\_cpucredit\_balance](#module\_rds\_cpucredit\_balance) | ./modules/datadog-monitor | n/a |
| <a name="module_rds_db_connections"></a> [rds\_db\_connections](#module\_rds\_db\_connections) | ./modules/datadog-monitor | n/a |
| <a name="module_rds_disk_queuedepth"></a> [rds\_disk\_queuedepth](#module\_rds\_disk\_queuedepth) | ./modules/datadog-monitor | n/a |
| <a name="module_rds_disk_usage"></a> [rds\_disk\_usage](#module\_rds\_disk\_usage) | ./modules/datadog-monitor | n/a |
| <a name="module_rds_mem_utilization"></a> [rds\_mem\_utilization](#module\_rds\_mem\_utilization) | ./modules/datadog-monitor | n/a |
| <a name="module_rds_read_iops"></a> [rds\_read\_iops](#module\_rds\_read\_iops) | ./modules/datadog-monitor | n/a |
| <a name="module_rds_read_latency"></a> [rds\_read\_latency](#module\_rds\_read\_latency) | ./modules/datadog-monitor | n/a |
| <a name="module_rds_read_throughput"></a> [rds\_read\_throughput](#module\_rds\_read\_throughput) | ./modules/datadog-monitor | n/a |
| <a name="module_rds_replica_lag"></a> [rds\_replica\_lag](#module\_rds\_replica\_lag) | ./modules/datadog-monitor | n/a |
| <a name="module_rds_write_iops"></a> [rds\_write\_iops](#module\_rds\_write\_iops) | ./modules/datadog-monitor | n/a |
| <a name="module_rds_write_latency"></a> [rds\_write\_latency](#module\_rds\_write\_latency) | ./modules/datadog-monitor | n/a |
| <a name="module_rds_write_throughput"></a> [rds\_write\_throughput](#module\_rds\_write\_throughput) | ./modules/datadog-monitor | n/a |
| <a name="module_redis_mem"></a> [redis\_mem](#module\_redis\_mem) | ./modules/datadog-monitor | n/a |
| <a name="module_system_cpu"></a> [system\_cpu](#module\_system\_cpu) | ./modules/datadog-monitor | n/a |
| <a name="module_system_disk"></a> [system\_disk](#module\_system\_disk) | ./modules/datadog-monitor | n/a |
| <a name="module_system_load"></a> [system\_load](#module\_system\_load) | ./modules/datadog-monitor | n/a |
| <a name="module_system_mem"></a> [system\_mem](#module\_system\_mem) | ./modules/datadog-monitor | n/a |
| <a name="module_unable_to_place_event"></a> [unable\_to\_place\_event](#module\_unable\_to\_place\_event) | ./modules/datadog-monitor | n/a |
| <a name="module_unscheduled_nodes"></a> [unscheduled\_nodes](#module\_unscheduled\_nodes) | ./modules/datadog-monitor | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb"></a> [alb](#input\_alb) | variable to enable elb monitors creation | `bool` | `false` | no |
| <a name="input_alb_queries"></a> [alb\_queries](#input\_alb\_queries) | Variabls for defining datadog alb queries. | `map(any)` | <pre>{<br>  "active_connection": "avg:aws.applicationelb.active_connection_count",<br>  "count_4xx": "avg:aws.applicationelb.httpcode_elb_4xx",<br>  "count_5xx": "avg:aws.applicationelb.httpcode_elb_5xx",<br>  "healthy_host": "avg:aws.applicationelb.healthy_host_count",<br>  "rejected": "avg:aws.applicationelb.rejected_connection_count",<br>  "request_count": "avg:aws.applicationelb.request_count",<br>  "response_time": "avg:aws.applicationelb.target_response_time.average",<br>  "unhealthy_host": "avg:aws.applicationelb.un_healthy_host_count"<br>}</pre> | no |
| <a name="input_ec"></a> [ec](#input\_ec) | variable to enable Elasticache monitors creation | `bool` | `false` | no |
| <a name="input_ec_alert_message"></a> [ec\_alert\_message](#input\_ec\_alert\_message) | Alert message to add in Elasticache monitors. | `string` | `"Value: {{value}}\nCluster: {{cacheclusterid.name}}\nNode: {{cachenodeid.name}}\nRegion: {{region.name}}\nEnvironment: {{Environment.name}}\n\n{{#is_no_data}}Not receiving data @pagerduty{{/is_no_data}}\n{{#is_alert}}@pagerduty{{/is_alert}}\n{{#is_warning}}@pagerduty{{/is_warning}}\n{{#is_recovery}}@pagerduty{{/is_recovery}}\n@slack-alerts\n"` | no |
| <a name="input_ec_queries"></a> [ec\_queries](#input\_ec\_queries) | Variabls for defining datadog Elasticache queries. | `map(any)` | <pre>{<br>  "cpu": "avg:aws.elasticache.cpuutilization",<br>  "current_conn": "avg:aws.elasticache.curr_connections",<br>  "engine_cpu": "avg:aws.elasticache.engine_cpuutilization",<br>  "evictions": "avg:aws.elasticache.evictions",<br>  "host_mem": "avg:aws.elasticache.freeable_memory",<br>  "lag": "avg:aws.elasticache.replication_lag",<br>  "memc_mem": "avg:aws.elasticache.bytes_used_for_cache_items",<br>  "redis_mem": "avg:aws.elasticache.bytes_used_for_cache"<br>}</pre> | no |
| <a name="input_ec_trigger_by"></a> [ec\_trigger\_by](#input\_ec\_trigger\_by) | Tags to trigger a separate alert for each tag mentioned. | `string` | `"{cacheclusterid,cachenodeid,Environment}"` | no |
| <a name="input_ecs"></a> [ecs](#input\_ecs) | Enable ecs monitors creation | `bool` | `false` | no |
| <a name="input_ecs_alert_message"></a> [ecs\_alert\_message](#input\_ecs\_alert\_message) | Alert message to add in all ecs monitors. | `string` | `"Cluster: {{clustername.name}}\nService: {{servicename.name}}\nEnvironment: {{Environment.name}}\n\n{{#is_no_data}}Not receiving data @pagerduty{{/is_no_data}}\n{{#is_alert}}@pagerduty{{/is_alert}}\n{{#is_warning}}@pagerduty{{/is_warning}}\n{{#is_recovery}}@pagerduty{{/is_recovery}}\n@slack-alerts\n"` | no |
| <a name="input_ecs_queries"></a> [ecs\_queries](#input\_ecs\_queries) | Variables for defining datadog ecs queries. | `map(any)` | <pre>{<br>  "cpu_reservation": "avg:aws.ecs.cpureservation",<br>  "cpu_utilization": "avg:aws.ecs.cpuutilization",<br>  "desired": "avg:aws.ecs.service.desired",<br>  "mem_reservation": "avg:aws.ecs.memory_reservation",<br>  "mem_utilization": "avg:aws.ecs.memory_utilization",<br>  "running": "avg:aws.ecs.service.running"<br>}</pre> | no |
| <a name="input_ecs_trigger_by"></a> [ecs\_trigger\_by](#input\_ecs\_trigger\_by) | Tags to trigger a separate alert for each tag mentioned. | `string` | `"{clustername,servicename,region,Environment}"` | no |
| <a name="input_elb"></a> [elb](#input\_elb) | variable to enable elb monitors creation | `bool` | `false` | no |
| <a name="input_elb_alert_message"></a> [elb\_alert\_message](#input\_elb\_alert\_message) | Alert message to add in all AWS elb and alb monitors. | `string` | `"Value: {{value}}\nName: {{host.name}}\nRegion: {{region.name}}\nEnvironment: {{Environment.name}}\n\n{{#is_no_data}}Not receiving data @pagerduty{{/is_no_data}}\n{{#is_alert}}@pagerduty{{/is_alert}}\n{{#is_warning}}@pagerduty{{/is_warning}}\n{{#is_recovery}}@pagerduty{{/is_recovery}}\n@slack-alerts\n"` | no |
| <a name="input_elb_queries"></a> [elb\_queries](#input\_elb\_queries) | Variabls for defining datadog elb queries. | `map(any)` | <pre>{<br>  "active_connection": "avg:aws.elb.active_connection_count",<br>  "count_4xx": "avg:aws.elb.httpcode_elb_4xx",<br>  "count_5xx": "avg:aws.elb.httpcode_elb_5xx",<br>  "healthy_host": "avg:aws.elb.healthy_host_count",<br>  "latency": "avg:aws.elb.latency",<br>  "request_count": "avg:aws.elb.request_count",<br>  "response_time": "avg:aws.elb.target_response_time.average",<br>  "spill_over": "avg:aws.elb.spillover_count",<br>  "surge_queue_length": "avg:aws.elb.surge_queue_length",<br>  "unhealthy_host": "avg:aws.elb.unhealthy_host_count"<br>}</pre> | no |
| <a name="input_elb_trigger_by"></a> [elb\_trigger\_by](#input\_elb\_trigger\_by) | Tags to trigger a separate alert for each tag mentioned. | `string` | `"{host,region,Environment}"` | no |
| <a name="input_from"></a> [from](#input\_from) | Datadog Monitor option to evaluate data from tag defined.. | `map(any)` | <pre>{<br>  "tag": "Environment",<br>  "tag_value": "prod"<br>}</pre> | no |
| <a name="input_k8s"></a> [k8s](#input\_k8s) | variable to enable Kubernetes monitors creation | `bool` | `false` | no |
| <a name="input_k8s_alert_message"></a> [k8s\_alert\_message](#input\_k8s\_alert\_message) | Alert message to add in k8s monitors. | `string` | `"Cluster: {{kubernetes_cluster.name}}  \nStatefulset: {{statefulset.name}} \nReplicaset: {{replicaset.name}}\nDeployment: {{deployment.name}} \nPod: {{pod_name.name}}\nValue: {{value}}\nName: {{host.name}}\nRegion: {{region.name}}\nEnvironment: {{Environment.name}}\n\n{{#is_no_data}}Not receiving data @pagerduty{{/is_no_data}}\n{{#is_alert}}@pagerduty{{/is_alert}}\n{{#is_warning}}@pagerduty{{/is_warning}}\n{{#is_recovery}}@pagerduty{{/is_recovery}}\n@slack-alerts\n"` | no |
| <a name="input_k8s_pod_trigger_by"></a> [k8s\_pod\_trigger\_by](#input\_k8s\_pod\_trigger\_by) | Tags to trigger a separate alert for each tag mentioned. | `string` | `"{pod_name,replicaset,deployment,kube_namespace,kubernetes_cluster}"` | no |
| <a name="input_k8s_queries"></a> [k8s\_queries](#input\_k8s\_queries) | Variabls for defining datadog kubernetes queries. This works for eks also. | `map(any)` | <pre>{<br>  "available_replicas_depl": "avg:kubernetes_state.deployment.replicas_available",<br>  "desired_replicas_deploy": "avg:kubernetes_state.deployment.replicas_desired",<br>  "desired_replicas_rep_set": "avg:kubernetes_state.replicaset.replicas_desired",<br>  "desired_replicas_stateful": "sum:kubernetes_state.statefulset.replicas_desired",<br>  "kubelet_api": "kubernetes.kubelet.check.ping",<br>  "kuber_container_waiting": "max:kubernetes_state.container.waiting",<br>  "kuber_desired_daemonset": "avg:kubernetes_state.daemonset.desired",<br>  "kuber_failed_jobs": "avg:kubernetes_state.job.failed",<br>  "kuber_node_status": "sum:kubernetes_state.node.status",<br>  "kuber_pod_mem_limit": "avg:kubernetes.memory.limits",<br>  "kuber_pod_mem_requests": "avg:kubernetes.memory.requests",<br>  "kuber_pod_mem_usage": "avg:kubernetes.memory.usage",<br>  "kuber_ready_daemonset": "avg:kubernetes_state.daemonset.ready",<br>  "node_disk_pressure": "kubernetes_state.node.disk_pressure",<br>  "node_mem_pressure": "kubernetes_state.node.memory_pressure",<br>  "node_nw_unavailable": "kubernetes_state.node.network_unavailable",<br>  "node_outof_disk": "kubernetes_state.node.out_of_disk",<br>  "ready_replicas_rep_set": "avg:kubernetes_state.replicaset.replicas_ready",<br>  "ready_replicas_stateful": "sum:kubernetes_state.statefulset.replicas_ready"<br>}</pre> | no |
| <a name="input_k8s_trigger_by"></a> [k8s\_trigger\_by](#input\_k8s\_trigger\_by) | Tags to trigger a separate alert for each tag mentioned. | `string` | `"{statefulset,kubernetes_cluster,kube_namespace,replicaset,node}"` | no |
| <a name="input_lambda"></a> [lambda](#input\_lambda) | variable to enable lambda monitors creation | `bool` | `false` | no |
| <a name="input_lambda_alert_message"></a> [lambda\_alert\_message](#input\_lambda\_alert\_message) | Alert message to add in AWS Lambda monitors. | `string` | `"Value: {{value}}\nFunction: {{functionname.name}}\nRegion: {{region.name}}\nEnvironment: {{Environment.name}}\n\n{{#is_no_data}}Not receiving data @pagerduty{{/is_no_data}}\n{{#is_alert}}@pagerduty{{/is_alert}}\n{{#is_warning}}@pagerduty{{/is_warning}}\n{{#is_recovery}}@pagerduty{{/is_recovery}}\n@slack-alerts\n"` | no |
| <a name="input_lambda_queries"></a> [lambda\_queries](#input\_lambda\_queries) | Variabls for defining datadog AWS Lambda queries. | `map(any)` | <pre>{<br>  "concurrent": "avg:aws.lambda.concurrent_executions",<br>  "duration": "avg:aws.lambda.duration.maximum",<br>  "errors": "avg:aws.lambda.errors",<br>  "throttle": "avg:aws.lambda.throttles"<br>}</pre> | no |
| <a name="input_lambda_trigger_by"></a> [lambda\_trigger\_by](#input\_lambda\_trigger\_by) | Tags to trigger a separate alert for each tag mentioned. | `string` | `"{functionname,Environment}"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name/Title for datadog monitors | `map(any)` | <pre>{<br>  "alb_4xx": "ALB: 4xx Error count is high on ALB: {{host.name}}, ENV: {{Environment.name}}",<br>  "alb_5xx": "ALB: 5xx Error count is high on ALB: {{host.name}}, ENV: {{Environment.name}}",<br>  "alb_active_connection": "ALB: Active connection count is high on ALB: {{host.name}}, ENV: {{Environment.name}}",<br>  "alb_healthy_host": "ALB: Healthy host count is low on ALB: {{host.name}}, ENV: {{Environment.name}}",<br>  "alb_rejected": "ALB: Spill over count is high on ALB: {{host.name}}, ENV: {{Environment.name}}",<br>  "alb_request_count": "ALB: Request count is high on ALB: {{host.name}}, ENV: {{Environment.name}}",<br>  "alb_response_time": "ALB: Response time is high on ALB: {{host.name}}, ENV: {{Environment.name}}",<br>  "alb_unhealthy_host": "ALB: Unhealthy host count is high on ALB: {{host.name}}, ENV: {{Environment.name}}",<br>  "clustercpu_reservation": "ECS: CPU reservation is high on Cluster: {{clustername.name}}, ENV: {{Environment.name}}",<br>  "clustercpu_utilization": "ECS: CPU utilization is high on Cluster: {{clustername.name}}, ENV: {{Environment.name}}",<br>  "clustermem_reservation": "ECS: Memory reservation is high on Cluster: {{clustername.name}}, ENV: {{Environment.name}}",<br>  "clustermem_utilization": "ECS: Memory Utilization is high on Cluster: {{clustername.name}}, ENV: {{Environment.name}}",<br>  "count": "ECS: Difference in Desired and Running tasks count on Cluster: {{clustername.name}}, Service {{servicename.name}}",<br>  "ec_cpu": "Elasticache: CPU Utilization is high on Cluster: {{cacheclusterid.name}}",<br>  "ec_current_conn": "Elasticache: High number of Current Connections on Cluster: {{cacheclusterid.name}}",<br>  "ec_engine_cpu": "Elasticache: Engine CPU Utilization is high on Cluster: {{cacheclusterid.name}}",<br>  "ec_evictions": "Elasticache: Evictions count is high on Cluster: {{cacheclusterid.name}}",<br>  "ec_failover": "Elasticache: Elasticache failover triggered on Cluster: {{cacheclusterid.name}}",<br>  "ec_host_mem": "Elasticache: Host memory usage is high on Cluster: {{cacheclusterid.name}}",<br>  "ec_lag": "Elasticache: Lag is high on Cluster: {{cacheclusterid.name}}",<br>  "ec_memc_mem": "Elasticache: Memcached memory usage is high on Cluster: {{cacheclusterid.name}}",<br>  "ec_redis_mem": "Elasticache: Redis memory usage is high on Cluster: {{cacheclusterid.name}}",<br>  "elb_4xx": "ELB: 4xx Error count is high on ELB: {{host.name}}, ENV: {{Environment.name}}",<br>  "elb_5xx": "ELB: 5xx Error count is high on ELB: {{host.name}}, ENV: {{Environment.name}}",<br>  "elb_active_connection": "ELB: Active connection count is high on ELB: {{host.name}}, ENV: {{Environment.name}}",<br>  "elb_healthy_host": "ELB: Healthy host count is low on ELB: {{host.name}}, ENV: {{Environment.name}}",<br>  "elb_latency": "ELB: Latency is high on ELB: {{host.name}}, ENV: {{Environment.name}}",<br>  "elb_request_count": "ELB: Request count is high on ELB: {{host.name}}, ENV: {{Environment.name}}",<br>  "elb_response_time": "ELB: Response time is high on ELB: {{host.name}}, ENV: {{Environment.name}}",<br>  "elb_spill_over": "ELB: Spill over count is high on ELB: {{host.name}}, ENV: {{Environment.name}}",<br>  "elb_surge_queue_length": "ELB: Surge queue length is high on ELB: {{host.name}}, ENV: {{Environment.name}}",<br>  "elb_unhealthy_host": "ELB: Unhealthy host count is high on ELB: {{host.name}}, ENV: {{Environment.name}}",<br>  "k8s_crashloopbackoff": "Kubernetes: Pod is in CrashLoopBackOff state on Cluster: {{kubernetes_cluster.name}}",<br>  "k8s_daemonset": "Kubernetes: Difference in Desired and Running daemon pod on Cluster: {{kubernetes_cluster.name}}",<br>  "k8s_deployment": "Kubernetes: Difference in Desired and Running replicas on Deployment: {{deployment.name}}",<br>  "k8s_failed_job": "Kubernetes: Job failed on Cluster: {{kubernetes_cluster.name}}",<br>  "k8s_imagepull_backoff": "Kubernetes: Pod is in ImagePullBackOff state on Cluster: {{kubernetes_cluster.name}}",<br>  "k8s_pod_mem": "Kubernetes: Memory usage is high on Pod {{pod_name.name}} on Cluster: {{kubernetes_cluster.name}}",<br>  "k8s_replicaset": "Kubernetes: Difference in Desired and Running replicas on Replicaset: {{replicaset.name}}",<br>  "k8s_statefulset": "Kubernetes: Difference in Desired and Running replicas on Statefulset: {{statefulset.name}}",<br>  "kubelet_api": "Kubernetes: Kubelet API is not available on Cluster: {{kubernetes_cluster.name}}",<br>  "lambda_concurrent": "Lambda: High number of Concurrent executions on Function: {{functionname.name}}",<br>  "lambda_duration": "Lambda: Duration is high on Function: {{functionname.name}}",<br>  "lambda_errors": "Lambda: High number of errors on Function: {{functionname.name}}",<br>  "lambda_throttle": "Lambda: Invocations are throttled on Function: {{functionname.name}}",<br>  "node_disk_pressure": "Kubernetes: Node under disk pressure on Node {{node_name.name}} on Cluster: {{kubernetes_cluster.name}}",<br>  "node_mem_pressure": "Kubernetes: Node under memory pressure on Node {{node_name.name}} on Cluster: {{kubernetes_cluster.name}}",<br>  "node_nw_unavailable": "Kubernetes: Node network unavailable on Node {{node_name.name}} on Cluster: {{kubernetes_cluster.name}}",<br>  "node_out_of_disk": "Kubernetes: Node under disk pressure on Node {{node_name.name}} on Cluster: {{kubernetes_cluster.name}}",<br>  "rds_burst_balance": "RDS: CPU burst balance is low on RDS: {{dbinstanceidentifier.name}}, ENV: {{Environment.name}}",<br>  "rds_cpu_credit_balance": "RDS: CPU credit balance is low on RDS: {{dbinstanceidentifier.name}}, ENV: {{Environment.name}}",<br>  "rds_cpu_utilization": "RDS: CPU utilization is high on RDS: {{dbinstanceidentifier.name}}, ENV: {{Environment.name}}",<br>  "rds_db_connections": "RDS: DB conections are high on RDS: {{dbinstanceidentifier.name}}, ENV: {{Environment.name}}",<br>  "rds_disk_queue_depth": "RDS: Disk queue depth is high on RDS: {{dbinstanceidentifier.name}}, ENV: {{Environment.name}}",<br>  "rds_disk_usage": "RDS: Disk usage is high on RDS: {{dbinstanceidentifier.name}}, ENV: {{Environment.name}}",<br>  "rds_failover": "RDS: Failover triggered on RDS: {{dbinstanceidentifier.name}}, ENV: {{Environment.name}}",<br>  "rds_mem_utilization": "RDS: Memory usage is high on RDS: {{dbinstanceidentifier.name}}, ENV: {{Environment.name}}",<br>  "rds_read_iops": "RDS: Read IOPS is high on RDS: {{dbinstanceidentifier.name}}, ENV: {{Environment.name}}",<br>  "rds_read_latency": "RDS: Read latency is high on RDS: {{dbinstanceidentifier.name}}, ENV: {{Environment.name}}",<br>  "rds_read_throughput": "RDS: Read throughput is high on RDS: {{dbinstanceidentifier.name}}, ENV: {{Environment.name}}",<br>  "rds_replica_lag": "RDS: Replica Lag is high on RDS: {{dbinstanceidentifier.name}}, ENV: {{Environment.name}}",<br>  "rds_write_iops": "RDS: Write IOPS high on RDS: {{dbinstanceidentifier.name}}, ENV: {{Environment.name}}",<br>  "rds_write_latency": "RDS: Write latency is high on RDS: {{dbinstanceidentifier.name}}, ENV: {{Environment.name}}",<br>  "rds_write_throughput": "RDS: Write throughput is high on RDS: {{dbinstanceidentifier.name}}, ENV: {{Environment.name}}",<br>  "servicecpu_utilization": "ECS: CPU Utilization is high on Service: {{servicename.name}}, ENV: {{Environment.name}}",<br>  "servicemem_utilization": "ECS: Memory Utilization is high on Service: {{servicename.name}}, ENV: {{Environment.name}}",<br>  "system_cpu": "System: CPU usage is high on Host: {{host.name}}, ENV: {{Environment.name}}",<br>  "system_disk": "System: DISK usage is high on Host: {{host.name}}, Device: {{device.name}}, ENV: {{Environment.name}}}",<br>  "system_load": "System: Load is high on Host: {{host.name}}, ENV: {{Environment.name}}",<br>  "system_mem": "System: MEM usage is high on Host: {{host.name}}, ENV: {{Environment.name}}",<br>  "unable_to_place_task": "ECS: Unable to place task on Service: {{servicename.name}}, ENV: {{Environment.name}}",<br>  "unscheduled_nodes": "Kubernetes: High % of unscheduled nodes on Cluster: {{kubernetes_cluster.name}}"<br>}</pre> | no |
| <a name="input_rds"></a> [rds](#input\_rds) | Enable rds monitors creation | `bool` | `false` | no |
| <a name="input_rds_alert_message"></a> [rds\_alert\_message](#input\_rds\_alert\_message) | Alert message to add in all rds monitors. | `string` | `"Value: {{value}}\nRDS Name: {{dbinstanceidentifier.name}}\nRegion: {{region.name}}\nEnvironment: {{Environment.name}}\n\n{{#is_no_data}}Not receiving data @pagerduty{{/is_no_data}}\n{{#is_alert}}@pagerduty{{/is_alert}}\n{{#is_warning}}@pagerduty{{/is_warning}}\n{{#is_recovery}}@pagerduty{{/is_recovery}}\n@slack-alerts\n"` | no |
| <a name="input_rds_queries"></a> [rds\_queries](#input\_rds\_queries) | Variabls for defining datadog rds queries. | `map(any)` | <pre>{<br>  "burst_balance": "avg:aws.rds.burst_balance",<br>  "cpu_credit_balance": "avg:aws.rds.cpucredit_balance",<br>  "cpu_utilization": "avg:aws.rds.cpuutilization",<br>  "db_connections": "avg:aws.rds.database_connections",<br>  "disk_free": "avg:aws.rds.free_storage_space",<br>  "disk_queue_depth": "avg:aws.rds.disk_queue_depth",<br>  "disk_total": "avg:aws.rds.total_storage_space",<br>  "mem_utilization": "avg:aws.rds.freeable_memory",<br>  "read_iops": "avg:aws.rds.read_iops",<br>  "read_latency": "avg:aws.rds.read_latency",<br>  "read_throughput": "avg:aws.rds.read_throughput",<br>  "replica_lag": "avg:aws.rds.replica_lag",<br>  "write_iops": "avg:aws.rds.write_iops",<br>  "write_latency": "avg:aws.rds.write_latency",<br>  "write_throughput": "avg:aws.rds.write_throughput"<br>}</pre> | no |
| <a name="input_rds_trigger_by"></a> [rds\_trigger\_by](#input\_rds\_trigger\_by) | Tags to trigger a separate alert for each tag mentioned. | `string` | `"{Environment,dbinstanceidentifier,region}"` | no |
| <a name="input_system"></a> [system](#input\_system) | variable to enable system monitors creation | `bool` | `false` | no |
| <a name="input_system_alert_message"></a> [system\_alert\_message](#input\_system\_alert\_message) | Alert message to add in system monitors. | `string` | `"Value: {{value}}\nName: {{host.name}}\nRegion: {{region.name}}\nEnvironment: {{Environment.name}}\n\n{{#is_no_data}}Not receiving data @pagerduty{{/is_no_data}}\n{{#is_alert}}@pagerduty{{/is_alert}}\n{{#is_warning}}@pagerduty{{/is_warning}}\n{{#is_recovery}}@pagerduty{{/is_recovery}}\n@slack-alerts\n"` | no |
| <a name="input_system_queries"></a> [system\_queries](#input\_system\_queries) | Variabls for defining datadog alb queries. | `map(any)` | <pre>{<br>  "cpu": "avg:system.cpu.idle",<br>  "disk_free": "avg:system.disk.free",<br>  "disk_total": "avg:system.disk.total",<br>  "load": "avg:system.load.norm.5",<br>  "mem_total": "avg:system.mem.total",<br>  "mem_used": "avg:system.mem.used"<br>}</pre> | no |
| <a name="input_system_trigger_by"></a> [system\_trigger\_by](#input\_system\_trigger\_by) | Tags to trigger a separate alert for each tag mentioned. | `string` | `"{host,Environment}"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_output"></a> [output](#output\_output) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Contributing
If you want to contribute to this repository check all the guidelines specified [here](.github/CONTRIBUTING.md) before submitting a new PR.
