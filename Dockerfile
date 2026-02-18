# Use full Ubuntu image
FROM ubuntu:22.04

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install Java 17 + Maven + Python + essentials
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        openjdk-17-jdk \
        maven \
        git \
        curl \
        wget \
        ca-certificates \
        gnupg \
        python3 \
        python3-distutils \
        software-properties-common \
        python3-venv \
    && curl -sS https://bootstrap.pypa.io/get-pip.py | python3 \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app
COPY . .

# Build the Java JAR
RUN mvn clean package

# Install Python dependencies
RUN python3 -m pip install --no-cache-dir -r requirements.txt

# Expose port for Flask
EXPOSE 10000

# Start Flask
CMD ["bash", "start.sh"]
