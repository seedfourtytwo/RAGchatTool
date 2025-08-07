# Use Python 3.11 on Ubuntu to match course requirements
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install uv package manager
RUN pip install uv

# Copy project files
COPY pyproject.toml ./

# Install basic dependencies with uv
RUN uv sync

# Install PyTorch CPU and sentence-transformers separately to avoid CUDA
RUN uv pip install torch torchvision --index-url https://download.pytorch.org/whl/cpu
RUN uv pip install sentence-transformers==2.7.0

# Copy application code
COPY backend/ ./backend/
COPY frontend/ ./frontend/
COPY docs/ ./docs/
COPY run.sh ./

# Make run script executable
RUN chmod +x run.sh

# Expose port
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8000/api/courses || exit 1

# Default command
CMD ["./run.sh"]