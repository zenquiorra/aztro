# 1. Base image
FROM python:3.11-slim

# 2. Install OS-level build tools & headers for lxml/gevent
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      build-essential gcc wget file \
      python3.11-dev libpython3.11-dev \
      libxml2-dev libxslt1-dev \
      libffi-dev libev-dev \
    && wget -qO /usr/include/python3.11/longintrepr.h \
         https://raw.githubusercontent.com/python/cpython/3.11/Include/longintrepr.h \
    && rm -rf /var/lib/apt/lists/*

# 3. Set workdir
WORKDIR /app

# 4. Install Python dependencies
COPY requirements.txt .
RUN pip install --upgrade pip \
 && pip install --no-cache-dir -r requirements.txt

# 5. Copy the rest of the app
COPY . .

# 6. Bind to a known container port (Render maps $PORT → 10000 by default)
ENV PORT 10000
EXPOSE 10000

# 7. Launch with Gunicorn
CMD ["gunicorn", "app:app", "--bind", "0.0.0.0:10000", "--workers", "4"]
