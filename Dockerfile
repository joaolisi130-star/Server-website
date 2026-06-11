FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm-256color

RUN apt-get update && apt-get install -y \
    nginx \
    python3 \
    python3-pip \
    python3-venv \
    git \
    curl \
    wget \
    nano \
    vim \
    htop \
    btop \
    tmux \
    screen \
    zip \
    unzip \
    tar \
    gzip \
    p7zip-full \
    net-tools \
    iproute2 \
    iputils-ping \
    dnsutils \
    traceroute \
    procps \
    lsof \
    tree \
    jq \
    rsync \
    openssh-client \
    ca-certificates \
    build-essential \
    software-properties-common \
    cron \
    sudo \
    sqlite3 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . /app

RUN mkdir -p \
    /app/data \
    /app/uploads \
    /app/logs \
    /app/backups

RUN chmod -R 777 /app/data \
    && chmod -R 777 /app/uploads \
    && chmod -R 777 /app/logs \
    && chmod -R 777 /app/backups

RUN if [ -f requirements.txt ]; then \
    pip3 install --break-system-packages -r requirements.txt; \
    fi

RUN echo 'events {} \
http { \
server { \
listen 8080; \
location / { \
proxy_pass http://127.0.0.1:5000; \
proxy_set_header Host $host; \
proxy_set_header X-Real-IP $remote_addr; \
} \
} \
}' > /etc/nginx/nginx.conf

EXPOSE 8080

CMD bash -c "nginx && python3 app.py"
