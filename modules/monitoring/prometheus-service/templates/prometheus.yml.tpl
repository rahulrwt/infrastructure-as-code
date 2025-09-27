global:
  scrape_interval: 15s  
  evaluation_interval: 15s
  scrape_timeout: 10s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: '${app_name}-server'
    metrics_path: '${metrics_path}'
    scrape_interval: ${scrape_interval}

    ec2_sd_configs:
      - region: ${aws_region}
        filters:
          - name: "tag:aws:autoscaling:groupName"
            values: ["${asg_name}"]
    basic_auth:
      username: ${basic_auth_username}
      password: ${basic_auth_password}

    relabel_configs:
      - source_labels: [__meta_ec2_private_ip]
        regex: (.*)
        replacement: $1:${target_port}
        target_label: __address__
      
      - source_labels: [__meta_ec2_tag_Name]
        target_label: instance
