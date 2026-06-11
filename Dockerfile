FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm-256color
ENV PORT=8080

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
    tmux \
    screen \
    zip \
    unzip \
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
    sqlite3 \
    sudo \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . .

RUN mkdir -p \
    /app/data \
    /app/uploads \
    /app/logs \
    /app/backups

RUN python3 -m venv /venv

RUN /venv/bin/pip install --upgrade pip

RUN if [ -f requirements.txt ]; then \
    /venv/bin/pip install -r requirements.txt; \
    else \
    /venv/bin/pip install flask psutil gunicorn; \
    fi

RUN printf 'events {}\nhttp {\nserver {\nlisten 8080;\nlocation / {\nproxy_pass http://127.0.0.1:5000;\nproxy_set_header Host $host;\nproxy_set_header X-Real-IP $remote_addr;\n}\n}\n}\n' > /etc/nginx/nginx.conf

EXPOSE 8080

CMD bash -c "nginx && /venv/bin/python app.py"
