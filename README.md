# Course Materials RAG System

A Retrieval-Augmented Generation (RAG) system designed to answer questions about course materials using semantic search and AI-powered responses.

## Overview

This application is a full-stack web application that enables users to query course materials and receive intelligent, context-aware responses. It uses ChromaDB for vector storage, Anthropic's Claude for AI generation, and provides a modern web interface for interaction.

**Key Features:**
- 🤖 **Tool-enhanced RAG architecture** - Claude AI intelligently decides when to search
- 🗄️ **Dual ChromaDB collections** - Optimized course catalog + content storage  
- 🐳 **Docker support** - Easy deployment with Intel Mac compatibility
- 🔒 **Security-hardened** - Secure credential management
- 🎯 **4 Pre-loaded Courses** - Ready with 528+ chunks of course materials
- 🌐 **Modern Web UI** - Clean chat interface with source attribution

## Quick Start Options

### Option 1: Docker (Recommended) 🐳

Perfect for Intel Macs or users who want zero-configuration setup:

```bash
# 1. Clone and enter directory
git clone https://github.com/seedfourtytwo/RAGchatTool.git
cd RAGchatTool

# 2. Set up your API key
cp .env.example .env
# Edit .env and add your ANTHROPIC_API_KEY

# 3. Run with Docker Compose
docker-compose up --build
```

**Access at:** http://localhost:8000

### Option 2: Local Development 💻

For native Python development:

**Prerequisites:**
- Python 3.11+ (Python 3.13+ recommended)  
- uv (Python package manager)
- An Anthropic API key - [Get one here](https://console.anthropic.com/)

```bash
# 1. Install uv (if not already installed)
curl -LsSf https://astral.sh/uv/install.sh | sh

# 2. Install Python dependencies  
uv sync

# 3. Set up environment variables
cp .env.example .env
# Edit .env and add your ANTHROPIC_API_KEY

# 4. Run the application
chmod +x run.sh
./run.sh
```

## Access Points

Once running, you can access:
- **Web Interface:** http://localhost:8000
- **API Documentation:** http://localhost:8000/docs  
- **Course Statistics:** http://localhost:8000/api/courses

## Architecture

**Tool-Enhanced RAG Flow:**
```
Frontend → FastAPI → RAGSystem → Claude API ↔ SearchTool → ChromaDB
```

**Core Components:**
- **Backend:** FastAPI server with RAG orchestration
- **AI Generator:** Anthropic Claude with tool calling
- **Vector Store:** ChromaDB with course catalog + content collections
- **Search Tools:** Intelligent course search with source tracking
- **Frontend:** Modern chat interface with real-time responses

## Development

### Docker Development
```bash
# Rebuild after code changes
docker-compose up --build

# View logs
docker-compose logs -f

# Stop containers  
docker-compose down
```

### Local Development
```bash
# Development server with hot reload
cd backend
uv run uvicorn app:app --reload --port 8000

# Add new dependencies
uv add package-name
```

## Troubleshooting

**Common Issues:**

- **Intel Mac PyTorch Issues:** Use Docker setup (automatically handles compatibility)
- **API Key Errors:** Ensure `ANTHROPIC_API_KEY` is set in `.env` file
- **Port 8000 in use:** Change port in `docker-compose.yml` or `run.sh`
- **Dependencies:** Use `uv sync` to ensure compatible package versions

**For Windows:** Use Git Bash - [Download Git for Windows](https://git-scm.com/downloads/win)

