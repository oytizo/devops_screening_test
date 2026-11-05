# --- Build Stage ---
FROM python:3.11-slim AS builder

WORKDIR /build

RUN apt-get update && apt-get install -y --no-install-recommends gcc && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

# --- Final Production Stage ---
FROM python:3.11-slim AS runner

WORKDIR /app

# Copy python dependencies from builder
COPY --from=builder /root/.local /home/devops_user/.local
COPY ./app ./app

# Set PATH to find installed uvicorn modules
ENV PATH=/home/devops_user/.local/bin:$PATH

# Implement security best practice: Create and switch to a non-root system user
RUN useradd -u 10001 devops_user && chown -R devops_user:devops_user /app
USER devops_user

EXPOSE 8080

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080"]
