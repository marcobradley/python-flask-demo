# syntax=docker/dockerfile:1

# ── Build stage ──────────────────────────────────────────────────────────────
FROM python:3.12-slim AS builder

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir --target=/app/deps -r requirements.txt

# ── Runtime stage ─────────────────────────────────────────────────────────────
FROM python:3.12-slim

# Create a non-root user for security
RUN chmod 1777 /tmp \
    && addgroup --system appgroup && adduser --system --ingroup appgroup appuser

WORKDIR /app

# Copy installed dependencies from the build stage
COPY --from=builder /app/deps /app/deps
ENV PYTHONPATH=/app/deps

# Copy application source
COPY app.py .
COPY templates/ templates/
COPY static/ static/

USER appuser

EXPOSE 5000

# Use Gunicorn as the production WSGI server
CMD ["python", "-m", "gunicorn", "--bind", "0.0.0.0:5000", "--workers", "2", "--timeout", "60", "app:app"]
