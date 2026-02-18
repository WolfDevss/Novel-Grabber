# Base Ubuntu image
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install Java, Maven, Python essentials
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
        python3-venv \
        python3-distutils \
        software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app
COPY . .

# Build the Java jar
RUN mvn clean package

# Create a virtual environment and install Python packages
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Expose Flask port
EXPOSE 10000

# Start Flask
CMD ["bash", "start.sh"]
