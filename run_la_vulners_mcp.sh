#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load environment variables from .env file in the script's directory
if [ -f "$SCRIPT_DIR/.env" ]; then
    export $(grep -v '^#' "$SCRIPT_DIR/.env" | xargs)
else
    echo "Error: .env file not found in $SCRIPT_DIR"
    exit 1
fi

# Check if VULNERS_API_KEY is set
if [ -z "$VULNERS_API_KEY" ]; then
    echo "Error: VULNERS_API_KEY not found in .env file"
    exit 1
fi

# Stop existing container if running
docker stop la-vulners-mcp-http 2>/dev/null
docker rm la-vulners-mcp-http 2>/dev/null

# Run Docker container in HTTP mode with Vulners API key
echo "Starting Vulners MCP server in HTTP mode on port 8000..."
docker run -d \
  -p 8000:8000 \
  --name la-vulners-mcp-http \
  -e MCP_TRANSPORT=http \
  -e VULNERS_API_KEY="$VULNERS_API_KEY" \
  la-vulners-mcp

echo "✅ LA-Vulners-MCP HTTP server started on http://localhost:8000/mcp"
echo "📝 View logs: docker logs -f la-vulners-mcp-http"
echo "🛑 Stop server: docker stop la-vulners-mcp-http"

