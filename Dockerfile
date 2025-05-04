# Use the official slim Python image (Debian-based)
FROM python:3.11-slim

# 1. Install only runtime dependencies (no compilers/build tools)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 2. Set working directory
WORKDIR /app

# 3. Copy and install Python dependencies (prebuilt wheels)
COPY requirements.txt .
RUN pip install --upgrade pip \
 && pip install --no-cache-dir -r requirements.txt

# 4. Copy application source
COPY . .

# 5. Expose the port that Gunicorn will bind to
ENV PORT 10000
EXPOSE 10000

# 6. Start the Flask app using Gunicorn with 4 workers
CMD ["gunicorn", "app:app", "--bind", "0.0.0.0:10000", "--workers", "4"]
