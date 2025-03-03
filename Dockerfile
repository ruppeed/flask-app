# Use a minimal Python image
FROM python:3.11-slim


# Set working directory inside the container
WORKDIR /app


# Copy project files into the container
COPY . .


# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt


# Expose port 8080 for Cloud Run
EXPOSE 8080


# Run Gunicorn (entry point for Flask)
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:8080", "app:app"]