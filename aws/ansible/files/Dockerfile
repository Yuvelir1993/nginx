FROM python:3.13-slim

# Set the working directory in the container
WORKDIR /app

# Copy server.py to the container
COPY server.py /app/

# Expose the ports the server listens on
EXPOSE 7001 7002 7003

# Command to run the server
CMD ["python3", "server.py"]
