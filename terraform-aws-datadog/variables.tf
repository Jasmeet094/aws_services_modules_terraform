variable "ecs_queries" {
  description = "Variables for defining datadog ecs queries."
  default = {
    cpu_reservation = "avg:aws.ecs.cpureservation"
    cpu_utilization = "avg:aws.ecs.cpuutilization"
    mem_reservation = "avg:aws.ecs.memory_reservation"
    mem_utilization = "avg:aws.ecs.memory_utilization"
    desired         = "avg:aws.ecs.service.desired"
    running         = "avg:aws.ecs.service.running"
  }
  type = map(any)
}

variable "rds_queries" {
  description = "Variabls for defining datadog rds queries."
  default = {
    cpu_credit_balance = "avg:aws.rds.cpucredit_balance"
    disk_queue_depth   = "avg:aws.rds.disk_queue_depth"
    write_throughput   = "avg:aws.rds.write_throughput"
    read_throughput    = "avg:aws.rds.read_throughput"
    cpu_utilization    = "avg:aws.rds.cpuutilization"
    mem_utilization    = "avg:aws.rds.freeable_memory"
    db_connections     = "avg:aws.rds.database_connections"
    write_latency      = "avg:aws.rds.write_latency"
    burst_balance      = "avg:aws.rds.burst_balance"
    read_latency       = "avg:aws.rds.read_latency"
    replica_lag        = "avg:aws.rds.replica_lag"
    disk_total         = "avg:aws.rds.total_storage_space"
    write_iops         = "avg:aws.rds.write_iops"
    disk_free          = "avg:aws.rds.free_storage_space"
    read_iops          = "avg:aws.rds.read_iops"
  }
  type = map(any)
}

variable "elb_queries" {
  description = "Variabls for defining datadog elb queries."
  default = {
    surge_queue_length = "avg:aws.elb.surge_queue_length"
    active_connection  = "avg:aws.elb.active_connection_count"
    unhealthy_host     = "avg:aws.elb.unhealthy_host_count"
    response_time      = "avg:aws.elb.target_response_time.average"
    request_count      = "avg:aws.elb.request_count"
    healthy_host       = "avg:aws.elb.healthy_host_count"
    spill_over         = "avg:aws.elb.spillover_count"
    count_4xx          = "avg:aws.elb.httpcode_elb_4xx"
    count_5xx          = "avg:aws.elb.httpcode_elb_5xx"
    latency            = "avg:aws.elb.latency"
  }
  type = map(any)
}

variable "alb_queries" {
  description = "Variabls for defining datadog alb queries."
  default = {
    active_connection = "avg:aws.applicationelb.active_connection_count"
    unhealthy_host    = "avg:aws.applicationelb.un_healthy_host_count"
    response_time     = "avg:aws.applicationelb.target_response_time.average"
    request_count     = "avg:aws.applicationelb.request_count"
    healthy_host      = "avg:aws.applicationelb.healthy_host_count"
    count_4xx         = "avg:aws.applicationelb.httpcode_elb_4xx"
    count_5xx         = "avg:aws.applicationelb.httpcode_elb_5xx"
    rejected          = "avg:aws.applicationelb.rejected_connection_count"
  }
  type = map(any)
}

variable "system_queries" {
  description = "Variabls for defining datadog alb queries."
  default = {
    disk_total = "avg:system.disk.total"
    mem_total  = "avg:system.mem.total"
    disk_free  = "avg:system.disk.free"
    mem_used   = "avg:system.mem.used"
    load       = "avg:system.load.norm.5"
    cpu        = "avg:system.cpu.idle"
  }
  type = map(any)
}

variable "ec_queries" {
  description = "Variabls for defining datadog Elasticache queries."
  default = {
    current_conn = "avg:aws.elasticache.curr_connections"
    engine_cpu   = "avg:aws.elasticache.engine_cpuutilization"
    evictions    = "avg:aws.elasticache.evictions"
    redis_mem    = "avg:aws.elasticache.bytes_used_for_cache"
    memc_mem     = "avg:aws.elasticache.bytes_used_for_cache_items"
    host_mem     = "avg:aws.elasticache.freeable_memory"
    lag          = "avg:aws.elasticache.replication_lag"
    cpu          = "avg:aws.elasticache.cpuutilization"
  }
  type = map(any)
}

variable "k8s_queries" {
  description = "Variabls for defining datadog kubernetes queries. This works for eks also."
  default = {
    desired_replicas_stateful = "sum:kubernetes_state.statefulset.replicas_desired"
    desired_replicas_rep_set  = "avg:kubernetes_state.replicaset.replicas_desired"
    kuber_container_waiting   = "max:kubernetes_state.container.waiting"
    desired_replicas_deploy   = "avg:kubernetes_state.deployment.replicas_desired"
    available_replicas_depl   = "avg:kubernetes_state.deployment.replicas_available"
    ready_replicas_stateful   = "sum:kubernetes_state.statefulset.replicas_ready"
    kuber_desired_daemonset   = "avg:kubernetes_state.daemonset.desired"
    ready_replicas_rep_set    = "avg:kubernetes_state.replicaset.replicas_ready"
    kuber_pod_mem_requests    = "avg:kubernetes.memory.requests"
    kuber_ready_daemonset     = "avg:kubernetes_state.daemonset.ready"
    kuber_pod_mem_usage       = "avg:kubernetes.memory.usage"
    node_nw_unavailable       = "kubernetes_state.node.network_unavailable"
    kuber_pod_mem_limit       = "avg:kubernetes.memory.limits"
    node_disk_pressure        = "kubernetes_state.node.disk_pressure"
    node_mem_pressure         = "kubernetes_state.node.memory_pressure"
    kuber_node_status         = "sum:kubernetes_state.node.status"
    kuber_failed_jobs         = "avg:kubernetes_state.job.failed"
    node_outof_disk           = "kubernetes_state.node.out_of_disk"
    kubelet_api               = "kubernetes.kubelet.check.ping"
  }
  type = map(any)
}

variable "lambda_queries" {
  description = "Variabls for defining datadog AWS Lambda queries."
  default = {
    concurrent = "avg:aws.lambda.concurrent_executions"
    duration   = "avg:aws.lambda.duration.maximum"
    throttle   = "avg:aws.lambda.throttles"
    errors     = "avg:aws.lambda.errors"
  }
  type = map(any)
}

variable "name" {
  description = "Name/Title for datadog monitors"
  default = {
    clustercpu_reservation = "ECS: CPU reservation is high on Cluster: {{clustername.name}}, ENV: {{Environment.name}}"
    clustercpu_utilization = "ECS: CPU utilization is high on Cluster: {{clustername.name}}, ENV: {{Environment.name}}"
    clustermem_reservation = "ECS: Memory reservation is high on Cluster: {{clustername.name}}, ENV: {{Environment.name}}"
    clustermem_utilization = "ECS: Memory Utilization is high on Cluster: {{clustername.name}}, ENV: {{Environment.name}}"
    servicecpu_utilization = "ECS: CPU Utilization is high on Service: {{servicename.name}}, ENV: {{Environment.name}}"
    servicemem_utilization = "ECS: Memory Utilization is high on Service: {{servicename.name}}, ENV: {{Environment.name}}"
    unable_to_place_task   = "ECS: Unable to place task on Service: {{servicename.name}}, ENV: {{Environment.name}}"
    count                  = "ECS: Difference in Desired and Running tasks count on Cluster: {{clustername.name}}, Service {{servicename.name}}"

    rds_cpu_credit_balance = "RDS: CPU credit balance is low on RDS: {{dbinstanceidentifier.name}}, ENV: {{Environment.name}}"
    rds_disk_queue_depth   = "RDS: Disk queue depth is high on RDS: {{dbinstanceidentifier.name}}, ENV: {{Environment.name}}"
    rds_write_throughput   = "RDS: Write throughput is high on RDS: {{dbinstanceidentifier.name}}, ENV: {{Environment.name}}"
    rds_read_throughput    = "RDS: Read throughput is high on RDS: {{dbinstanceidentifier.name}}, ENV: {{Environment.name}}"
    rds_cpu_utilization    = "RDS: CPU utilization is high on RDS: {{dbinstanceidentifier.name}}, ENV: {{Environment.name}}"
    rds_mem_utilization    = "RDS: Memory usage is high on RDS: {{dbinstanceidentifier.name}}, ENV: {{Environment.name}}"
    rds_db_connections     = "RDS: DB conections are high on RDS: {{dbinstanceidentifier.name}}, ENV: {{Environment.name}}"
    rds_write_latency      = "RDS: Write latency is high on RDS: {{dbinstanceidentifier.name}}, ENV: {{Environment.name}}"
    rds_burst_balance      = "RDS: CPU burst balance is low on RDS: {{dbinstanceidentifier.name}}, ENV: {{Environment.name}}"
    rds_read_latency       = "RDS: Read latency is high on RDS: {{dbinstanceidentifier.name}}, ENV: {{Environment.name}}"
    rds_replica_lag        = "RDS: Replica Lag is high on RDS: {{dbinstanceidentifier.name}}, ENV: {{Environment.name}}"
    rds_disk_usage         = "RDS: Disk usage is high on RDS: {{dbinstanceidentifier.name}}, ENV: {{Environment.name}}"
    rds_write_iops         = "RDS: Write IOPS high on RDS: {{dbinstanceidentifier.name}}, ENV: {{Environment.name}}"
    rds_read_iops          = "RDS: Read IOPS is high on RDS: {{dbinstanceidentifier.name}}, ENV: {{Environment.name}}"
    rds_failover           = "RDS: Failover triggered on RDS: {{dbinstanceidentifier.name}}, ENV: {{Environment.name}}"

    elb_surge_queue_length = "ELB: Surge queue length is high on ELB: {{host.name}}, ENV: {{Environment.name}}"
    elb_active_connection  = "ELB: Active connection count is high on ELB: {{host.name}}, ENV: {{Environment.name}}"
    elb_unhealthy_host     = "ELB: Unhealthy host count is high on ELB: {{host.name}}, ENV: {{Environment.name}}"
    elb_response_time      = "ELB: Response time is high on ELB: {{host.name}}, ENV: {{Environment.name}}"
    elb_request_count      = "ELB: Request count is high on ELB: {{host.name}}, ENV: {{Environment.name}}"
    elb_healthy_host       = "ELB: Healthy host count is low on ELB: {{host.name}}, ENV: {{Environment.name}}"
    elb_spill_over         = "ELB: Spill over count is high on ELB: {{host.name}}, ENV: {{Environment.name}}"
    elb_latency            = "ELB: Latency is high on ELB: {{host.name}}, ENV: {{Environment.name}}"
    elb_4xx                = "ELB: 4xx Error count is high on ELB: {{host.name}}, ENV: {{Environment.name}}"
    elb_5xx                = "ELB: 5xx Error count is high on ELB: {{host.name}}, ENV: {{Environment.name}}"

    alb_active_connection = "ALB: Active connection count is high on ALB: {{host.name}}, ENV: {{Environment.name}}"
    alb_unhealthy_host    = "ALB: Unhealthy host count is high on ALB: {{host.name}}, ENV: {{Environment.name}}"
    alb_request_count     = "ALB: Request count is high on ALB: {{host.name}}, ENV: {{Environment.name}}"
    alb_response_time     = "ALB: Response time is high on ALB: {{host.name}}, ENV: {{Environment.name}}"
    alb_healthy_host      = "ALB: Healthy host count is low on ALB: {{host.name}}, ENV: {{Environment.name}}"
    alb_rejected          = "ALB: Spill over count is high on ALB: {{host.name}}, ENV: {{Environment.name}}"
    alb_4xx               = "ALB: 4xx Error count is high on ALB: {{host.name}}, ENV: {{Environment.name}}"
    alb_5xx               = "ALB: 5xx Error count is high on ALB: {{host.name}}, ENV: {{Environment.name}}"

    system_disk = "System: DISK usage is high on Host: {{host.name}}, Device: {{device.name}}, ENV: {{Environment.name}}}"
    system_load = "System: Load is high on Host: {{host.name}}, ENV: {{Environment.name}}"
    system_mem  = "System: MEM usage is high on Host: {{host.name}}, ENV: {{Environment.name}}"
    system_cpu  = "System: CPU usage is high on Host: {{host.name}}, ENV: {{Environment.name}}"

    ec_current_conn = "Elasticache: High number of Current Connections on Cluster: {{cacheclusterid.name}}"
    ec_engine_cpu   = "Elasticache: Engine CPU Utilization is high on Cluster: {{cacheclusterid.name}}"
    ec_evictions    = "Elasticache: Evictions count is high on Cluster: {{cacheclusterid.name}}"
    ec_redis_mem    = "Elasticache: Redis memory usage is high on Cluster: {{cacheclusterid.name}}"
    ec_failover     = "Elasticache: Elasticache failover triggered on Cluster: {{cacheclusterid.name}}"
    ec_memc_mem     = "Elasticache: Memcached memory usage is high on Cluster: {{cacheclusterid.name}}"
    ec_host_mem     = "Elasticache: Host memory usage is high on Cluster: {{cacheclusterid.name}}"
    ec_lag          = "Elasticache: Lag is high on Cluster: {{cacheclusterid.name}}"
    ec_cpu          = "Elasticache: CPU Utilization is high on Cluster: {{cacheclusterid.name}}"

    k8s_imagepull_backoff = "Kubernetes: Pod is in ImagePullBackOff state on Cluster: {{kubernetes_cluster.name}}"
    k8s_crashloopbackoff  = "Kubernetes: Pod is in CrashLoopBackOff state on Cluster: {{kubernetes_cluster.name}}"
    node_nw_unavailable   = "Kubernetes: Node network unavailable on Node {{node_name.name}} on Cluster: {{kubernetes_cluster.name}}"
    node_disk_pressure    = "Kubernetes: Node under disk pressure on Node {{node_name.name}} on Cluster: {{kubernetes_cluster.name}}"
    node_mem_pressure     = "Kubernetes: Node under memory pressure on Node {{node_name.name}} on Cluster: {{kubernetes_cluster.name}}"
    unscheduled_nodes     = "Kubernetes: High % of unscheduled nodes on Cluster: {{kubernetes_cluster.name}}"
    node_out_of_disk      = "Kubernetes: Node under disk pressure on Node {{node_name.name}} on Cluster: {{kubernetes_cluster.name}}"
    k8s_statefulset       = "Kubernetes: Difference in Desired and Running replicas on Statefulset: {{statefulset.name}}"
    k8s_replicaset        = "Kubernetes: Difference in Desired and Running replicas on Replicaset: {{replicaset.name}}"
    k8s_deployment        = "Kubernetes: Difference in Desired and Running replicas on Deployment: {{deployment.name}}"
    k8s_failed_job        = "Kubernetes: Job failed on Cluster: {{kubernetes_cluster.name}}"
    k8s_daemonset         = "Kubernetes: Difference in Desired and Running daemon pod on Cluster: {{kubernetes_cluster.name}}"
    k8s_pod_mem           = "Kubernetes: Memory usage is high on Pod {{pod_name.name}} on Cluster: {{kubernetes_cluster.name}}"
    kubelet_api           = "Kubernetes: Kubelet API is not available on Cluster: {{kubernetes_cluster.name}}"

    lambda_concurrent = "Lambda: High number of Concurrent executions on Function: {{functionname.name}}"
    lambda_duration   = "Lambda: Duration is high on Function: {{functionname.name}}"
    lambda_throttle   = "Lambda: Invocations are throttled on Function: {{functionname.name}}"
    lambda_errors     = "Lambda: High number of errors on Function: {{functionname.name}}"
  }
  type = map(any)
}

# Trigger a separate alert for each defined parameter.
variable "ecs_trigger_by" {
  description = "Tags to trigger a separate alert for each tag mentioned."
  default     = "{clustername,servicename,region,Environment}"
  type        = string
}

variable "rds_trigger_by" {
  description = "Tags to trigger a separate alert for each tag mentioned."
  default     = "{Environment,dbinstanceidentifier,region}"
  type        = string
}

variable "elb_trigger_by" {
  description = "Tags to trigger a separate alert for each tag mentioned."
  default     = "{host,region,Environment}"
  type        = string
}

variable "system_trigger_by" {
  description = "Tags to trigger a separate alert for each tag mentioned."
  default     = "{host,Environment}"
  type        = string
}

variable "ec_trigger_by" {
  description = "Tags to trigger a separate alert for each tag mentioned."
  default     = "{cacheclusterid,cachenodeid,Environment}"
  type        = string
}

variable "k8s_pod_trigger_by" {
  description = "Tags to trigger a separate alert for each tag mentioned."
  default     = "{pod_name,replicaset,deployment,kube_namespace,kubernetes_cluster}"
  type        = string
}

variable "k8s_trigger_by" {
  description = "Tags to trigger a separate alert for each tag mentioned."
  default     = "{statefulset,kubernetes_cluster,kube_namespace,replicaset,node}"
  type        = string
}

variable "lambda_trigger_by" {
  description = "Tags to trigger a separate alert for each tag mentioned."
  default     = "{functionname,Environment}"
  type        = string
}

variable "from" {
  description = "Datadog Monitor option to evaluate data from tag defined.."
  default = {
    tag       = "Environment"
    tag_value = "prod"
  }
  type = map(any)
}

# Message-Footer for all monitors.
variable "ecs_alert_message" {
  description = "Alert message to add in all ecs monitors."
  default     = <<EOF
Cluster: {{clustername.name}}
Service: {{servicename.name}}
Environment: {{Environment.name}}

{{#is_no_data}}Not receiving data @pagerduty{{/is_no_data}}
{{#is_alert}}@pagerduty{{/is_alert}}
{{#is_warning}}@pagerduty{{/is_warning}}
{{#is_recovery}}@pagerduty{{/is_recovery}}
@slack-alerts
EOF
  type        = string
}

variable "rds_alert_message" {
  description = "Alert message to add in all rds monitors."
  default     = <<EOF
Value: {{value}}
RDS Name: {{dbinstanceidentifier.name}}
Region: {{region.name}}
Environment: {{Environment.name}}

{{#is_no_data}}Not receiving data @pagerduty{{/is_no_data}}
{{#is_alert}}@pagerduty{{/is_alert}}
{{#is_warning}}@pagerduty{{/is_warning}}
{{#is_recovery}}@pagerduty{{/is_recovery}}
@slack-alerts
EOF
  type        = string
}

variable "elb_alert_message" {
  description = "Alert message to add in all AWS elb and alb monitors."
  default     = <<EOF
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
  type        = string
}

variable "system_alert_message" {
  description = "Alert message to add in system monitors."
  default     = <<EOF
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
  type        = string
}

variable "ec_alert_message" {
  description = "Alert message to add in Elasticache monitors."
  default     = <<EOF
Value: {{value}}
Cluster: {{cacheclusterid.name}}
Node: {{cachenodeid.name}}
Region: {{region.name}}
Environment: {{Environment.name}}

{{#is_no_data}}Not receiving data @pagerduty{{/is_no_data}}
{{#is_alert}}@pagerduty{{/is_alert}}
{{#is_warning}}@pagerduty{{/is_warning}}
{{#is_recovery}}@pagerduty{{/is_recovery}}
@slack-alerts
EOF
  type        = string
}

variable "k8s_alert_message" {
  description = "Alert message to add in k8s monitors."
  default     = <<EOF
Cluster: {{kubernetes_cluster.name}}  
Statefulset: {{statefulset.name}} 
Replicaset: {{replicaset.name}}
Deployment: {{deployment.name}} 
Pod: {{pod_name.name}}
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
  type        = string
}

variable "lambda_alert_message" {
  description = "Alert message to add in AWS Lambda monitors."
  default     = <<EOF
Value: {{value}}
Function: {{functionname.name}}
Region: {{region.name}}
Environment: {{Environment.name}}

{{#is_no_data}}Not receiving data @pagerduty{{/is_no_data}}
{{#is_alert}}@pagerduty{{/is_alert}}
{{#is_warning}}@pagerduty{{/is_warning}}
{{#is_recovery}}@pagerduty{{/is_recovery}}
@slack-alerts
EOF
  type        = string
}

variable "ecs" {
  description = "Enable ecs monitors creation"
  default     = false
  type        = bool
}

variable "rds" {
  description = "Enable rds monitors creation"
  default     = false
  type        = bool
}

variable "elb" {
  description = "variable to enable elb monitors creation"
  default     = false
  type        = bool
}

variable "alb" {
  description = "variable to enable elb monitors creation"
  default     = false
  type        = bool
}

variable "system" {
  description = "variable to enable system monitors creation"
  default     = false
  type        = bool
}

variable "ec" {
  description = "variable to enable Elasticache monitors creation"
  default     = false
  type        = bool
}

variable "k8s" {
  description = "variable to enable Kubernetes monitors creation"
  default     = false
  type        = bool
}

variable "lambda" {
  description = "variable to enable lambda monitors creation"
  default     = false
  type        = bool
}

variable "tags" {
  description = "Tags to apply to all resources"
  default     = {}
  type        = map(any)
}