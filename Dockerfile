# 1. Base image
FROM python:3.11-slim

# 2. Install only runtime OS deps
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 3. Set working directory
WORKDIR /app

# 4. Copy & install Python deps:
#    - First pin MarkupSafe to 2.0.1 (has soft_unicode)
#    - Then install the rest (lxml, gevent via prebuilt wheels)
COPY requirements.txt .
RUN pip install --upgrade pip \
 && pip install --no-cache-dir markupsafe==2.0.1 \
 && pip install --no-cache-dir -r requirements.txt

# 5. Copy application code
COPY . .

# 6. Expose and run with Gunicorn
ENV PORT 10000
EXPOSE 10000
CMD ["gunicorn", "app:app", "--bind", "0.0.0.0:10000", "--workers", "4"]
