FROM python:3.11-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc python3-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy requirements first for better caching
COPY requirements.txt .

# Install Python dependencies with specific settings for reliability
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir --timeout=100 -r requirements.txt

# Copy application files
COPY . .

# Expose the port
EXPOSE $PORT

# Command to run the application
CMD gunicorn -k uvicorn.workers.UvicornWorker -w 1 --timeout 300 --keep-alive 120 --preload main:app -b 0.0.0.0:$PORT 