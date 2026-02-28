# Kubernetes

A local Kubernetes dev platform running on your Mac. One command gives you a full cluster with git hosting, CI/CD, object storage, a managed database, and a web dashboard — all accessible at `*.dev.test` in your browser.

## What you get

| Service | URL | What it does |
|---------|-----|--------------|
| **Forgejo** | forgejo.dev.test | Git hosting — like GitHub, but yours |
| **Woodpecker** | ci.dev.test | CI/CD — runs pipelines when you push |
| **MinIO** | minio.dev.test | Object storage UI — S3 on your laptop |
| **MinIO API** | s3.dev.test | S3-compatible endpoint for apps |
| **Headlamp** | headlamp.dev.test | Kubernetes dashboard — see everything |
| **PostgreSQL** | cluster-internal | Managed database via CloudNativePG |
| **Traefik** | — | Routes traffic to the right service |

## Getting started

### Prerequisites

This setup assumes you've already built the dotfiles (`darwin-rebuild switch --flake .#your-hostname`). That gives you:

- **colima** — lightweight VM that runs your cluster
- **kubectl** — talk to Kubernetes
- **helm** — install apps from charts (packages for Kubernetes)
- **k9s** — terminal UI for your cluster

### Start the cluster

```bash
colima start --runtime k3s \
  --cpu 6 \
  --memory 12 \
  --disk 100 \
  --vm-type vz \
  --network-address
```

| Flag | What it does |
|------|-------------|
| `--runtime k3s` | Runs [k3s](https://k3s.io), a lightweight Kubernetes distribution |
| `--cpu 6` | Allocate 6 CPU cores to the VM |
| `--memory 12` | Allocate 12 GiB RAM |
| `--disk 100` | 100 GiB virtual disk |
| `--vm-type vz` | Use Apple's [Virtualization.framework](https://developer.apple.com/documentation/virtualization) (faster than QEMU) |
| `--network-address` | Assign a routable IP to the VM (needed for DNS routing) |

Tune `--cpu` and `--memory` to your machine. 4 CPUs / 8 GiB is a reasonable minimum. First boot downloads the image and takes a minute. Subsequent starts are fast.

> These options are saved to `~/.colima/default/colima.yaml` after the first run. Future `colima start` commands reuse them — you only need the full flags on first setup or when changing resources.

### Verify it works

```bash
kubectl get nodes
```

You should see one node named `colima` with status `Ready`:

```
NAME     STATUS   ROLES                  AGE   VERSION
colima   Ready    control-plane,master   1m    v1.33.4+k3s1
```

### Stop the cluster

```bash
colima stop
```

Your data persists between stops. Everything comes back when you start again.

## How traffic flows

When you visit `forgejo.dev.test` in your browser, here's what happens:

```
Browser
  → macOS resolver (/etc/resolver/dev.test)
    → dnsmasq (127.0.0.1:53) resolves *.dev.test to 192.168.64.3
      → Colima VM (192.168.64.3)
        → Traefik ingress controller (matches hostname)
          → Forgejo service (cluster-internal)
```

Every service gets its own `*.dev.test` subdomain. Traefik reads the hostname from the request and routes it to the right pod. No port numbers to remember, no `/etc/hosts` to edit — it just works.

## DNS setup

Two pieces make wildcard DNS work:

### 1. dnsmasq (in `modules/darwin.nix`)

```nix
services.dnsmasq.enable = true;
services.dnsmasq.addresses = {
  "dev.test" = "192.168.64.3"; # Replace with your actual Colima IP
};
```

This runs a local DNS server that resolves any `*.dev.test` address to the Colima VM.

### 2. macOS resolver

nix-darwin creates `/etc/resolver/dev.test` which tells macOS: "for anything ending in `.dev.test`, ask dnsmasq instead of your normal DNS."

### Troubleshooting DNS

If `*.dev.test` doesn't resolve:

```bash
# Check that Colima's IP matches the dnsmasq config
colima list   # look for the IP address

# Flush macOS DNS cache
sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder

# Test resolution directly
dig hello.dev.test @127.0.0.1

# Verify dnsmasq is running
sudo lsof -i :53
```

If Colima's IP changed (rare), update the address in `modules/darwin.nix` and rebuild.

## Deploy your first app

Let's deploy a web app to the cluster and access it at `hello.dev.test`. This walks through the core Kubernetes workflow: write a Helm chart, install it, see it live.

### What's a Helm chart?

A Helm chart is a package for Kubernetes. Instead of writing raw YAML manifests, you write templates with configurable values. Think of it like a `package.json` but for infrastructure.

### Create the chart

```bash
mkdir -p hello-chart/templates
```

**hello-chart/Chart.yaml** — metadata:

```yaml
apiVersion: v2
name: hello
version: 0.1.0
description: My first Kubernetes app
```

**hello-chart/values.yaml** — configurable defaults:

```yaml
image: nginx:alpine
replicas: 1
host: hello.dev.test
```

**hello-chart/templates/deployment.yaml** — runs your app:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Release.Name }}
spec:
  replicas: {{ .Values.replicas }}
  selector:
    matchLabels:
      app: {{ .Release.Name }}
  template:
    metadata:
      labels:
        app: {{ .Release.Name }}
    spec:
      containers:
        - name: app
          image: {{ .Values.image }}
          ports:
            - containerPort: 80
```

**hello-chart/templates/service.yaml** — makes it reachable inside the cluster:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: {{ .Release.Name }}
spec:
  selector:
    app: {{ .Release.Name }}
  ports:
    - port: 80
      targetPort: 80
```

**hello-chart/templates/ingress.yaml** — exposes it at your domain:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ .Release.Name }}
spec:
  ingressClassName: traefik
  rules:
    - host: {{ .Values.host }}
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: {{ .Release.Name }}
                port:
                  number: 80
```

### Deploy it

```bash
kubectl create namespace hello
helm install hello ./hello-chart -n hello
```

### Verify

```bash
kubectl get pods -n hello     # should show 1/1 Running
kubectl get ingress -n hello  # should show hello.dev.test
```

Open [http://hello.dev.test](http://hello.dev.test) in your browser. You should see the nginx welcome page.

### Iterate

Change something in `values.yaml` (like `replicas: 3`) and upgrade:

```bash
helm upgrade hello ./hello-chart -n hello
kubectl get pods -n hello  # now shows 3 pods
```

### Clean up

```bash
helm uninstall hello -n hello
kubectl delete namespace hello
```

## Platform services

### Forgejo (git hosting)

Self-hosted git forge at **forgejo.dev.test**. Create repos, manage issues, review PRs — everything you'd do on GitHub, running locally. Stores data in the PostgreSQL database. Supports OAuth2, so other services (like Headlamp) can authenticate through it.

### Woodpecker (CI/CD)

Continuous integration at **ci.dev.test**. Connects to Forgejo — when you push code, Woodpecker picks up the pipeline defined in your repo's `.woodpecker.yml` and runs it as Kubernetes jobs. The agent runs build steps directly in the cluster.

### MinIO (object storage)

S3-compatible storage. The console at **minio.dev.test** lets you manage buckets and files visually. Apps can use the S3 API at **s3.dev.test** with standard AWS SDKs — just point the endpoint to `s3.dev.test` instead of AWS.

### PostgreSQL (database)

Managed by [CloudNativePG](https://cloudnative-pg.io), a Kubernetes operator that handles backups, failover, and lifecycle. Services connect via `postgres-rw.postgres.svc.cluster.local:5432` inside the cluster.

### Headlamp (dashboard)

Kubernetes web UI at **headlamp.dev.test**. See your pods, deployments, logs, and events in a clean interface. Authenticates via Forgejo using OpenID Connect.

## Shell aliases

| Alias | Command |
|-------|---------|
| `k` | `kubectl` |
| `kgp` | `kubectl get pods` |
| `kgs` | `kubectl get svc` |
| `kga` | `kubectl get all` |
| `kns` | `kubectl config set-context --current --namespace` |
| `h` | `helm` |
| `lzk` | `k9s` |

Set your default namespace to avoid typing `-n` every time:

```bash
kns my-namespace
```

## Tools

### k9s (terminal dashboard)

```bash
k9s
# or use the alias
lzk
```

Navigate pods, view logs, exec into containers, delete resources — all from the terminal. Press `?` for help, `:` to switch resource views (e.g., `:deploy`, `:svc`, `:ing`).

### Headlamp (web dashboard)

Visit [headlamp.dev.test](http://headlamp.dev.test) for a graphical overview. Good for exploring when you're still learning what resources exist.

## Common operations

```bash
# View logs from a pod
kubectl logs <pod-name> -n <namespace>
kubectl logs -f <pod-name> -n <namespace>  # follow (stream)

# See why a pod isn't starting
kubectl describe pod <pod-name> -n <namespace>

# Access a service locally (without ingress)
kubectl port-forward svc/<service> 8080:80 -n <namespace>
# then visit http://localhost:8080

# Restart a deployment (pulls fresh image if using :latest)
kubectl rollout restart deployment/<name> -n <namespace>

# Exec into a running container
kubectl exec -it <pod-name> -n <namespace> -- /bin/sh

# See resource usage
kubectl top pods -n <namespace>
kubectl top nodes
```

## Quick reference

```bash
# Start / stop
colima start --kubernetes
colima stop

# Cluster health
kubectl get nodes
kubectl get pods --all-namespaces

# What's deployed
helm list --all-namespaces

# Everything in a namespace
kubectl get all -n <namespace>
```
