FROM python:3.11-slim

RUN apt-get update && apt-get install -y wget git curl && rm -rf /var/lib/apt/lists/*
WORKDIR /app

# Install supercronic for cron job scheduling
ADD https://github.com/aptible/supercronic/releases/latest/download/supercronic-linux-amd64 /usr/local/bin/supercronic
RUN chmod +x /usr/local/bin/supercronic

COPY run.sh update.sh prepper_server.py requirements.txt ./
COPY templates ./templates

RUN pip install --no-cache-dir -r requirements.txt
RUN chmod +x /app/run.sh /app/update.sh

EXPOSE 8080
CMD ["/app/run.sh"]
