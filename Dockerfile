# Use full Ubuntu image for reliable apt-get
FROM ubuntu:22.04

# Install Java 17 + Maven + essentials
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        openjdk-17-jdk \
        maven \
        git \
        curl \
        wget \
        ca-certificates \
        gnupg \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app
COPY . .

# Build the Java JAR
RUN mvn clean package

# Install Python dependencies
RUN apt-get install -y python3-pip && pip3 install -r requirements.txt

# Expose Flask port
EXPOSE 10000

# Start Flask
CMD ["bash", "start.sh"]
