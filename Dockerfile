FROM python:3.11-slim

# Install dependencies needed for apt + Java + Maven
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    curl \
    gnupg \
    ca-certificates \
    apt-transport-https \
    software-properties-common \
    openjdk-17-jdk \
    maven \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app
COPY . .

# Build the Java jar
RUN mvn clean package

# Install Python dependencies
RUN pip install -r requirements.txt

# Expose port for Flask
EXPOSE 10000

# Start the API
CMD ["bash", "start.sh"]
