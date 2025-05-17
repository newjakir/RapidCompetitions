FROM python:3.10-slim

# Expose service port
EXPOSE 8000

# Avoid Python .pyc files and buffer logs
ENV PYTHONDONTWRITEBYTECODE=1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED=1

# Upgrade pip tools
RUN python -m pip install --upgrade pip setuptools wheel

# Install system-level dependencies
COPY requirements.txt .
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    zlib1g-dev \
    libffi-dev \
    libpq-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set work directory and copy requirements first
WORKDIR /app

# Copy project code
COPY . /app

# Install Python dependencies
RUN python -m pip install -r requirements.txt

# Generate a Django SECRET_KEY and save to .env (for use with django-environ)
#RUN python -c "from django.core.management.utils import get_random_secret_key as g; \
#key = g(); open('.env', 'w').write(f'SECRET_KEY={key}\n')"

# Start the app
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
