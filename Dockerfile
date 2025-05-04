# 1. Base image
FROM python:3.11-slim

# 2. Install only runtime OS deps
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 3. Set working directory
WORKDIR /app

# 4. Copy requirements
COPY requirements.txt .

# 5. Pre-pin MarkupSafe and Jinja2, then install the rest
RUN pip install --upgrade pip \
 && pip install --no-cache-dir \
      markupsafe==2.0.1 \          # bring back soft_unicode  
      jinja2==2.11.3            && # uses collections.abc.Mapping  
    pip install --no-cache-dir -r requirements.txt

# 6. Copy application code
COPY . .

# 7. Expose and run with Gunicorn
ENV PORT 10000
EXPOSE 10000
CMD ["gunicorn", "app:app", "--bind", "0.0.0.0:10000", "--workers", "4"]
