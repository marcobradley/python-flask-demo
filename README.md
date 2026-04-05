# python-flask-demo

A containerized Python Flask web application designed to run on a [k3s](https://k3s.io/) Kubernetes cluster.

## Project structure

```
.
├── app.py              # Flask application
├── requirements.txt    # Python dependencies
├── Dockerfile          # Multi-stage Docker image
├── .dockerignore
└── k8s/
    ├── deployment.yaml # Kubernetes Deployment (2 replicas)
    ├── service.yaml    # ClusterIP Service
    └── ingress.yaml    # Traefik Ingress (k3s default)
```

## Endpoints

| Route     | Description                       |
|-----------|-----------------------------------|
| `GET /`   | Returns a JSON greeting message   |
| `GET /health` | Liveness / readiness probe    |

## Local development

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python app.py
```

The app will be available at <http://localhost:5000>.

## Docker

Build and run the container locally:

```bash
docker build -t flask-demo:latest .
docker run -p 5000:5000 flask-demo:latest
```

## Deploy to k3s

### 1. Build and load the image

On each k3s node (or via a registry), make the image available:

```bash
docker build -t flask-demo:latest .
# Import directly into k3s containerd (no registry needed):
docker save flask-demo:latest | sudo k3s ctr images import -
```

### 2. Apply the manifests

```bash
kubectl apply -f k8s/
```

### 3. Verify the deployment

```bash
kubectl get pods
kubectl get svc
kubectl get ingress
```

### 4. Access the app

Add the following entry to `/etc/hosts` (replace `<NODE_IP>` with your k3s node IP):

```
<NODE_IP>  flask-demo.local
```

Then open <http://flask-demo.local> in your browser or run:

```bash
curl http://flask-demo.local
```