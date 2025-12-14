# ALB Architecture with Cloudflare

```
┌─────────────────────────────────────────────────────────────────┐
│                         CLOUDFLARE DNS                          │
│                                                                 │
│  CNAME: app.example.com → alb-xxxxx.us-east-1.elb.amazonaws.com│
└────────────────────────┬────────────────────────────────────────┘
                         │
                         │ DNS Resolution
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                    AWS Application Load Balancer                │
│                   (alb-xxxxx.us-east-1.elb.amazonaws.com)       │
│                                                                 │
│  ┌───────────────────────────────────────────────────┐     │
│  │              Listener Rules (Port 80/443)             │     │
│  │                                                       │     │
│  │  Rule 1: IF host = api.ghanshyamtech.online          │     │
│  │          THEN forward to → Backend Target Group      │     │
│  │                                                       │     │
│  │  Rule 2: IF host = * (default)                       │     │
│  │          THEN forward to → Frontend Target Group     │     │
│  └───────────────────────────────────────────────────────┘     │
│                         │                  │                    │
└─────────────────────────┼──────────────────┼────────────────────┘
                          │                  │
        ┌─────────────────┘                  └─────────────────┐
        │                                                      │
        ▼                                                      ▼
┌──────────────────────────┐                    ┌──────────────────────────┐
│  Backend Target Group    │                    │  Frontend Target Group   │
│  (Port 8080/3000)        │                    │  (Port 80/3000)          │
│                          │                    │                          │
│  Health Check:           │                    │  Health Check:           │
│  Path: /api/health       │                    │  Path: /                 │
│  Interval: 30s           │                    │  Interval: 30s           │
│                          │                    │                          │
│  ┌─────────────────┐     │                    │  ┌─────────────────┐     │
│  │   EC2 Instance  │     │                    │  │   EC2 Instance  │     │
│  │   Backend-1     │     │                    │  │   Frontend-1    │     │
│  │   10.0.1.10     │     │                    │  │   10.0.2.10     │     │
│  └─────────────────┘     │                    │  └─────────────────┘     │
│                          │                    │                          │
│  ┌─────────────────┐     │                    │  ┌─────────────────┐     │
│  │   EC2 Instance  │     │                    │  │   EC2 Instance  │     │
│  │   Backend-2     │     │                    │  │   Frontend-2    │     │
│  │   10.0.1.11     │     │                    │  │   10.0.2.11     │     │
│  └─────────────────┘     │                    │  └─────────────────┘     │
└──────────────────────────┘                    └──────────────────────────┘

         AZ-1                                            AZ-2
```

## Configuration Details

### 1. Cloudflare CNAME Configuration
```
# Frontend Domain
Type: CNAME
Name: app (or www)
Target: alb-xxxxx.us-east-1.elb.amazonaws.com
Proxy Status: Proxied (Orange Cloud)
TTL: Auto

# Backend API Domain
Type: CNAME
Name: api
Target: alb-xxxxx.us-east-1.elb.amazonaws.com
Proxy Status: Proxied (Orange Cloud)
TTL: Auto
```

### 2. ALB Listener Rules

**Rule Priority 1 - Backend API Traffic:**
- Condition: Host header = `api.ghanshyamtech.online`
- Action: Forward to Backend Target Group
- Targets: Backend EC2 instances (Node.js/Express, Python/Flask, etc.)

**Rule Priority 2 - Frontend Traffic (Default):**
- Condition: Host header = `*` (all other domains)
- Action: Forward to Frontend Target Group
- Targets: Frontend EC2 instances (React, Vue, Angular, etc.)

### 3. Target Group Configuration

**Backend Target Group:**
- Protocol: HTTP
- Port: 8080 (or your backend port)
- Health Check Path: `/hello`
- Stickiness: Enabled (optional)

**Frontend Target Group:**
- Protocol: HTTP
- Port: 80 or 3000
- Health Check Path: `/` or `/health`
- Stickiness: Enabled (optional)

### 4. Traffic Flow Example

```
User Request: https://api.ghanshyamtech.online/users
    ↓
Cloudflare DNS Resolution (CNAME: api → ALB)
    ↓
ALB receives request
    ↓
Host header matches api.ghanshyamtech.online → Routes to Backend Target Group
    ↓
Backend EC2 Instance processes API request


User Request: https://www.ghanshyamtech.online/
    ↓
Cloudflare DNS Resolution (CNAME: app → ALB)
    ↓
ALB receives request
    ↓
Host header matches default rule → Routes to Frontend Target Group
    ↓
Frontend EC2 Instance serves web application
```

## Benefits of This Architecture

1. **Cloudflare Integration:**
   - DDoS protection
   - CDN caching
   - SSL/TLS encryption
   - WAF (Web Application Firewall)

2. **ALB Path-Based Routing:**
   - Single load balancer for multiple services
   - Cost-effective
   - Simplified DNS management
   - Independent scaling of frontend/backend

3. **High Availability:**
   - Multi-AZ deployment
   - Health checks ensure traffic only to healthy instances
   - Auto-scaling capability
