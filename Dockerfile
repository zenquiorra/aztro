# 1. Start from a Debian-slim Python image
FROM python:3.11-slim

# 2. Install OS-level build dependencies for lxml, gevent, etc.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      build-essential \
      gcc \
      libxml2-dev \
      libxslt1-dev \
      python3-dev \
      libffi-dev \
    && rm -rf /var/lib/apt/lists/*

# 3. Create app directory
WORKDIR /app

# 4. Copy only requirements, install them (leverages Docker cache)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copy the rest of your code
COPY . .

# 6. Expose the port Render will bind via $PORT
ENV PORT 10000
EXPOSE 10000

# 7. Launch with Gunicorn
CMD ["gunicorn", "app:app", "--bind", "0.0.0.0:10000", "--workers", "4"]
