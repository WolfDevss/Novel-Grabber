# Use full Debian image instead of slim
FROM python:3.11

# Install Java 17 + Maven + basic tools
RUN apt-get update && apt-get install -y \
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
RUN pip install -r requirements.txt

# Expose port for Flask
EXPOSE 10000

# Start Flask app
CMD ["bash", "start.sh"]
