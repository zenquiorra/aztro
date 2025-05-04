# 1. Base image
FROM python:3.11-slim

# 2. Install only runtime OS deps
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# 3. Set working directory
WORKDIR /app

# 4. Copy requirements
COPY requirements.txt .

# 5. Upgrade pip
RUN pip install --upgrade pip

# 6. Pin MarkupSafe & Jinja2 before installing the rest
RUN pip install --no-cache-dir \
      markupsafe==2.0.1 \
      jinja2==2.11.3

# 7. Install your remaining dependencies
RUN pip install --no-cache-dir -r requirements.txt

# 8. Copy application code
COPY . .

# 9. Expose and run with Gunicorn
ENV PORT 10000
EXPOSE 10000
CMD ["gunicorn", "app:app", "--bind", "0.0.0.0:10000", "--workers", "4"]
