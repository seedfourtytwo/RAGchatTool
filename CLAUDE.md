# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a RAG (Retrieval-Augmented Generation) chatbot system that allows users to query course materials and receive intelligent, context-aware responses. The system uses a modern tool-enhanced RAG architecture where Claude AI intelligently decides when to search for information rather than always retrieving.

## Development Commands

**IMPORTANT: Always use `uv` for all dependency management and running commands. Do NOT use pip directly.**

### Setup and Installation
```bash
# Install dependencies (never use pip install)
uv sync

# Create environment file
cp .env.example .env
# Add your ANTHROPIC_API_KEY to .env

# Quick start
chmod +x run.sh
./run.sh
```

### Running the Application
```bash
# Development server (with hot reload) - always use uv run
cd backend
uv run uvicorn app:app --reload --port 8000

# Production server - always use uv run
cd backend  
uv run uvicorn app:app --host 0.0.0.0 --port 8000

# Adding new dependencies - use uv add, never pip install
uv add package-name
```

### Docker Setup (Recommended for Intel Macs)

For Intel Macs experiencing PyTorch compatibility issues:

```bash
# Build and run with Docker Compose (recommended)
docker-compose up --build

# Or build and run manually
docker build -t rag-chatbot .
docker run -p 8000:8000 -e ANTHROPIC_API_KEY=$ANTHROPIC_API_KEY rag-chatbot
```

### Access Points
- Web Interface: http://localhost:8000
- API Documentation: http://localhost:8000/docs
- Course Statistics: http://localhost:8000/api/courses

## Architecture Overview

### Core RAG Pipeline
The system implements a **tool-enhanced RAG architecture** rather than traditional always-retrieve RAG:

1. **Document Processing** → **Vector Storage** → **Tool-Based Retrieval** → **AI Generation**
2. Claude AI uses tool calling to decide when and how to search for information
3. Two-collection ChromaDB setup: `course_catalog` (metadata) + `course_content` (chunks)

### Key Components

**Backend Modules** (`backend/`):
- `rag_system.py` - Main orchestrator coordinating all components
- `ai_generator.py` - Anthropic Claude API integration with tool calling
- `vector_store.py` - ChromaDB abstraction with dual-collection architecture  
- `search_tools.py` - Tool-based search system with source tracking
- `document_processor.py` - Structured document parsing and chunking
- `session_manager.py` - In-memory conversation history management
- `app.py` - FastAPI server with CORS and static file serving

**Frontend** (`frontend/`):
- Modern chat interface with real-time updates
- Sidebar with course statistics and suggested questions
- Markdown rendering and source attribution
- Session persistence across interactions

### Document Format
Expected course document structure:
```
Course Title: [title]
Course Link: [url]  
Course Instructor: [instructor]

Lesson 0: Introduction
Lesson Link: [lesson-url]
[lesson content...]

Lesson 1: [lesson-title]
[lesson content...]
```

## Configuration

### Key Settings (`config.py`)
- `CHUNK_SIZE`: 800 characters
- `CHUNK_OVERLAP`: 100 characters
- `MAX_RESULTS`: 5 search results returned
- `MAX_HISTORY`: 2 conversation exchanges retained
- `ANTHROPIC_MODEL`: claude-sonnet-4-20250514

### Environment Variables (`.env`)
```bash
ANTHROPIC_API_KEY=sk-ant-api03-...  # Required
```

## Tool-Enhanced RAG System

### How It Works
1. User submits query via web interface
2. RAG system builds prompt with conversation history  
3. Claude API called with tools enabled
4. Claude decides whether to use search tool based on query
5. If search needed: `CourseSearchTool` queries vector store
6. Search results formatted with course/lesson context
7. Claude generates response using retrieved context
8. Sources tracked and displayed to user

### Search Tool Capabilities
- Semantic search across course content
- Smart course name resolution (handles partial matches like "MCP")
- Lesson-specific filtering (`lesson_number` parameter)
- Source attribution with course and lesson context

## Data Flow

### Document Ingestion (Startup)
```
docs/ folder → DocumentProcessor → Course/Chunk objects → VectorStore → ChromaDB
```

### Query Processing
```  
Frontend → FastAPI → RAGSystem → AIGenerator → Claude API ↔ SearchTool → VectorStore → ChromaDB
```

### Session Management
- Sessions auto-created for new users
- Conversation history passed to Claude for context
- In-memory storage (resets on restart)

## Development Considerations

### Adding New Document Types
Modify `document_processor.py` to handle additional file formats (currently supports PDF, DOCX, TXT).

### Extending Search Capabilities  
New tools can be registered with `ToolManager` - follow the `Tool` interface pattern in `search_tools.py`.

### Frontend Customization
- Suggested questions: `frontend/index.html` (lines 45-49)
- UI themes and styling: `frontend/style.css`
- Chat behavior: `frontend/script.js`

### Database Persistence
ChromaDB data persists in `./chroma_db` directory. Delete this folder to reset the knowledge base.

## Troubleshooting

### Common Issues
- **API Key**: Ensure valid Anthropic API key in `.env`
- **Port Conflicts**: Application runs on port 8000 by default
- **Document Loading**: Check console logs during startup for processing errors
- **Dependencies**: Use `uv sync` to ensure compatible package versions

### Debugging RAG Flow
- Monitor search tool execution via console logs
- Check `/api/courses` endpoint to verify document ingestion
- Use `/docs` endpoint to test API endpoints directly
- Sources are displayed in UI for response transparency

## Package Management

**This project exclusively uses `uv` for fast, reliable Python dependency management. NEVER use pip directly.**

### uv Commands
- `uv sync` - Install/update all dependencies from lockfile
- `uv add package-name` - Add new dependency to project
- `uv remove package-name` - Remove dependency from project
- `uv run command` - Run commands in the uv environment
- `uv pip list` - List installed packages (if needed for debugging)

The `pyproject.toml` defines core dependencies including ChromaDB, Anthropic SDK, SentenceTransformers, and FastAPI. All dependency changes should go through uv to maintain compatibility and reproducibility.

## Best Practices

- Always use uv to run the server, do not use PIP directly
- Use uv to run Python files