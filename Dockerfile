FROM python:3.11-slim

# Install Java + Maven
RUN apt-get update && apt-get install -y \
    openjdk-17-jdk \
    maven \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .

# Build the Java jar
RUN mvn clean package

# Install Python deps
RUN pip install -r requirements.txt

EXPOSE 10000

CMD ["bash", "start.sh"]
