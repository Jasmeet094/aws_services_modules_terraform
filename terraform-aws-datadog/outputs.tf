output "output" {
  value = {
    Cluster_CPU_Reservation = module.ecs_cluster_cpu_reservation.output
    Cluster_CPU_Utilization = module.ecs_cluster_cpu_utilization.output
    Cluster_MEM_Reservation = module.ecs_cluster_mem_reservation.output
    Cluster_MEM_utilization = module.ecs_cluster_mem_utilization.output
    Service_CPU_Utilization = module.ecs_service_cpu_utilization.output
    Service_MEM_Utilization = module.ecs_service_mem_utilization.output
    Task_Count              = module.ecs_task_count.output

    RDS_Write_Throughput = module.rds_write_throughput.output
    RDS_Read_Throughput  = module.rds_read_throughput.output
    RDS_CPU_Utilization  = module.rds_cpu_utilization.output
    RDS_MEM_Utilization  = module.rds_mem_utilization.output
    RDS_Disk_Queuedepth  = module.rds_disk_queuedepth.output
    RDS_DB_Connections   = module.rds_db_connections.output
    RDS_Credit_Balance   = module.rds_cpucredit_balance.output
    RDS_Burst_Balance    = module.rds_burst_balance.output
    RDS_Write_Latency    = module.rds_write_latency.output
    RDS_Read_Latency     = module.rds_read_latency.output
    RDS_Replica_Lag      = module.rds_replica_lag.output
    RDS_Write_IOPS       = module.rds_write_iops.output
    RDS_Disk_Usage       = module.rds_disk_usage.output
    RDS_Read_IOPS        = module.rds_read_iops.output

    ELB_Unhealthy_Host_Count = module.elb_unhealthy_host_count.output
    ELB_Target_Response_Time = module.elb_target_response_time.output
    ELB_Surge_Queue_Length   = module.elb_surge_queue_length.output
    ELB_Healthy_Host_Count   = module.elb_healthy_host_count.output
    ELB_Active_Connection    = module.active_connection.output
    ELB_Request_Count        = module.elb_request_count.output
    ELB_Spillover            = module.elb_spillover.output
    ELB_Latency              = module.elb_latency.output
    ELB_4xx                  = module.elb_4xx.output
    ELB_5xx                  = module.elb_5xx.output

    ALB_Target_Response_Time = module.alb_target_response_time.output
    ALB_Unhealthy_Host_Count = module.alb_unhealthy_host_count.output
    ALB_Healthy_Host_Count   = module.alb_healthy_host_count.output
    ALB_Active_Connection    = module.alb_active_connection.output
    ALB_Request_Count        = module.alb_request_count.output
    ALB_Rejected             = module.alb_rejected.output
    ALB_4xx                  = module.alb_4xx.output
    ALB_5xx                  = module.alb_5xx.output

    EC_Current_Conn = module.current_conn.output
    EC_Engine_CPU   = module.engine_cpu_utilization.output
    EC_Redis_Mem    = module.redis_mem.output
    EC_Evictions    = module.evictions.output
    EC_Memc_Mem     = module.memc_mem.output
    EC_Host_mem     = module.host_mem.output
    EC_Lag          = module.lag.output
    EC_CPU          = module.cpu_utilization.output

    k8s_node_nw_unavailable = module.node_nw_unavailable.output
    k8s_node_disk_pressure  = module.node_disk_pressure.output
    k8s_node_mem_pressure   = module.node_mem_pressure.output
    k8s_unscheduled_nodes   = module.unscheduled_nodes.output
    k8s_imagepull_backoff   = module.imagepull_backoff.output
    k8s_crashloopbackoff    = module.crashloopbackoff.output
    K8s_Statefulset         = module.diff_in_replica_statefulset.output
    K8s_Replicaset          = module.diff_in_replica_replicaset.output
    K8s_Deployment          = module.diff_in_replicas_deployment.output
    K8s_Daemonpod           = module.diff_in_nodes_daemonset.output
    k8s_job_fail            = module.job_failed.output
    k8s_Pod_Mem             = module.pod_memory.output

    Lambda_concurrent = module.lambda_concurrent_executions.output
    Lambda_duration   = module.lambda_duration.output
    Lambda_throttle   = module.lambda_throtttle_executions.output
    Lambda_error      = module.lambda_errors.output
  }
}