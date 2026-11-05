# DevOps Intern Screening Task Application

A containerized Python FastAPI web service backed by a GitHub Actions CI pipeline and system health tracking utilities.

## Local Application Management

### Startup Instructions
Run the container ecosystem on your local loopback address (Port 8080):
```bash
docker-compose up -d
```

### Verification
Query the running web service endpoint:
```bash
curl http://localhost:8080/
```
Expected Output payload:
```json
{"message": "Hello from DevOps Intern Task!", "status": "running"}
```

---

## System Health Script Setup

The automated health script checks fundamental OS tracking telemetry and generates metrics alerts.

### Setting Permissions
Grant execution permissions to the script file:
```bash
chmod +x system_health.sh
```

### Script Execution
Execute the script using:
```bash
./system_health.sh
```
*   Metric results are appended continuously into `health_log.txt`.
*   If your root partition usage scale breaks past 80%, the console returns a warning block directly.

---

## AWS Deployment Architecture Strategy

*   **Continuous Deployment Execution Strategy (GitOps):** Configure a clean deployment job runner on GitHub Actions using `appleboy/ssh-action`. Once image compilation processes settle safely on Docker Hub, the runner signs directly into the targeted AWS EC2 node over secure SSH. It pulls the updated image version from the registry and performs a zero-downtime rolling restart (`docker compose pull && docker compose up -d`).
*   **Infrastructure Layout & Security Constraints:** Deploy the EC2 application host into an AWS VPC Private Subnet to block direct internet vector attacks. Route inbound web traffic through an AWS Application Load Balancer (ALB) operating in the Public Subnets, handling traffic filtering and secure TLS termination.
*   **Operational Health Monitoring:** Configure an on-instance cron schedule running every 5 minutes to trigger `system_health.sh`. Rather than letting raw text strings build up passively inside `health_log.txt`, pipe alerts directly out into AWS CloudWatch Metrics logs to generate real-time Slack or SMS infrastructure alerts via AWS SNS.
