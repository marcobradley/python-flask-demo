# python-flask-demo

A containerized Python Flask web application designed to run on a [k3s](https://k3s.io/) Kubernetes cluster.

> **Kubernetes manifests** are managed separately in [marcobradley/local-kubernetes-cluster-demo](https://github.com/marcobradley/local-kubernetes-cluster-demo).

## Project structure

```
.
├── app.py              # Flask application
├── requirements.txt    # Python dependencies
├── Dockerfile          # Multi-stage Docker image
└── .dockerignore
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

Kubernetes manifests (Deployment, Service, Ingress) are maintained in the [local-kubernetes-cluster-demo](https://github.com/marcobradley/local-kubernetes-cluster-demo) repository. See that repo for deployment instructions.

Build and push (or import) the Docker image so it is available to your cluster nodes:

```bash
docker build -t flask-demo:latest .
# Import directly into k3s containerd (no registry needed):
docker save flask-demo:latest | sudo k3s ctr images import -
```