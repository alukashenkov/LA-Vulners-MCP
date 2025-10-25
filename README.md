# LA-Vulners-MCP

[![MCP Server](https://img.shields.io/badge/MCP-Server-6E56CF)](https://modelcontextprotocol.io) [![FastMCP 2.0](https://img.shields.io/badge/FastMCP-2.0-00A67E)](https://github.com/jlowin/fastmcp) [![Docker ready](https://img.shields.io/badge/Docker-ready-2496ED?logo=docker&logoColor=white)](#docker-deployment) [![Python 3.13+](https://img.shields.io/badge/Python-3.13%2B-3776AB?logo=python&logoColor=white)](#framework) [![License: AGPL v3](https://img.shields.io/badge/License-AGPL_v3-blue.svg)](LICENSE)

![Vulners MCP Banner](images/banner.png)

**LA-Vulners-MCP** is a Model Context Protocol (MCP) server that provides comprehensive vulnerability intelligence from the Vulners API. Built with [FastMCP 2.0](https://github.com/jlowin/fastmcp), it delivers multi-layered CVE analysis, security bulletin information, and connected document discovery through flexible transport modes optimized for AI assistants (Claude, Cursor) and MCP client frameworks (CrewAI).

## Framework

This server is built on **[FastMCP 2.0](https://github.com/jlowin/fastmcp)**, a modern Python framework for creating MCP servers with minimal boilerplate:

- **Dual Transport Support**: Native stdio (for Claude/Cursor) and HTTP (for CrewAI/VM-Agent) modes
- **Type-Safe Tool Definitions**: Pydantic-based parameter validation with explicit descriptions
- **Automatic Tool Discovery**: MCP clients automatically discover available tools and their schemas
- **Zero Configuration**: Simple `@mcp.tool()` decorator for exposing Python functions as MCP tools
- **Docker-First Design**: Optimized for containerized deployment with single-command setup

## Features

### CVE Analysis Tool (`vulners_cve_info`)

Comprehensive vulnerability intelligence including:

- **Core CVE Data**: Official CVE ID, publication date, title, and detailed description
- **Multi-Source Risk Scoring**: CVSS v3.1/v4.0 scores from NVD and CNA sources, SSVC stakeholder decision support, and EPSS exploit prediction scores with percentile rankings
- **Weakness Analysis**: CWE classifications with consequence analysis (security scopes and potential impacts) and related CAPEC attack patterns with cross-framework taxonomy mappings
- **Exploitation Intelligence**: Real-world exploitation status with authoritative source attribution (CISA KEV, Shadowserver)
- **Affected Products**: Platform-aware product listings with intelligent vendor deduplication
- **Connected Document Discovery**: Related security intelligence from 200+ sources including vendor advisories, vulnerability chains, solutions, and workarounds

**Parameters:**

- `cve_id` (string): CVE identifier in format CVE-YYYY-NNNNN (e.g., CVE-2024-1234, CVE-2021-44228). Case-insensitive.

### Security Bulletin Tool (`vulners_bulletin_info`)

Essential bulletin information for non-CVE security documents including:

- **Bulletin Metadata**: Official ID, publication date, title, and comprehensive description for GHSA, RHSA, NASL, and vendor advisories
- **CVE Cross-References**: Complete list of CVE identifiers mentioned in bulletins
- **Reference Links**: Official advisory URLs, vendor patches, and technical documentation
- **Bulletin Classification**: Document type and classification

**Parameters:**

- `bulletin_id` (string): Security bulletin identifier from RELATED_DOCUMENTS section (e.g., GHSA-xxxx-xxxx-xxxx, RHSA-YYYY:NNNN, DSA-NNNN-N). **Note**: Do NOT use CVE IDs here.

### JSON Output Structure

Both tools return structured JSON optimized for automated processing.

<details>
<summary><strong>Click to expand: CVE Analysis Tool Response (<code>CveInfoOutput</code>)</strong></summary>

```json
{
  "success": true,
  "error": null,
  "cve_id": "CVE-2021-44228",
  "core_info": {
    "id": "CVE-2021-44228",
    "published": "2021-12-10T20:15:00.000Z",
    "description": "Apache Log4j2 2.0-beta9 through 2.14.1 JNDI features...",
    "title": "Apache Log4j2 JNDI Remote Code Execution",
    "type": "cve",
    "href": "https://vulners.com/cve/CVE-2021-44228"
  },
  "cvss_metrics": [
    {
      "version": "3.1",
      "source": "NVD",
      "base_score": 10.0,
      "base_severity": "CRITICAL",
      "vector_string": "CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:C/C:H/I:H/A:H",
      "v4_fields": null
    }
  ],
  "ssvc_metrics": [
    {
      "role": "Provider",
      "version": "2.0",
      "options": ["Exploitation: active", "Automatable: yes"]
    }
  ],
  "epss_score": {
    "score": 0.97546,
    "percentile": 99.999,
    "date": "2021-12-15"
  },
  "cwe_classifications": ["CWE-502", "CWE-400"],
  "cwe_consequences": [
    {
      "cwe_id": "CWE-502",
      "name": "Deserialization of Untrusted Data",
      "consequences": {
        "scopes": ["Confidentiality", "Integrity", "Availability"],
        "impacts": ["Execute Unauthorized Code", "DoS: Crash/Exit/Restart"]
      },
      "related_capec": {
        "capec_ids": ["CAPEC-586", "CAPEC-588"],
        "capec_data": [
          {
            "id": "CAPEC-586",
            "name": "Object Injection",
            "taxonomy_mappings": [
              {
                "taxonomy": "OWASP Top Ten 2021",
                "entry_id": "A08",
                "entry_name": "Software and Data Integrity Failures"
              }
            ]
          }
        ]
      }
    }
  ],
  "exploitation_status": {
    "wild_exploited": true,
    "sources": ["CISA", "Shadowserver"],
    "shadowserver_items": [
      {
        "source": "Shadowserver CVE-2021-44228 Scan"
      }
    ]
  },
  "affected_products": [
    "Apache Log4j 2.x for Java",
    "Apache Log4j 2.x for Linux",
    "Apache Log4j 2.x for Windows"
  ],
  "references": [
    "https://logging.apache.org/log4j/2.x/security.html",
    "https://www.cisa.gov/known-exploited-vulnerabilities-catalog"
  ],
  "related_cves": ["CVE-2021-45046", "CVE-2021-45105", "CVE-2021-44832"],
  "solutions": [
    "Update to Apache Log4j 2.17.0 or later",
    "Apply vendor patches immediately",
    "Remove JndiLookup class from classpath"
  ],
  "workarounds": [
    "Set system property log4j2.formatMsgNoLookups to true",
    "Remove JndiLookup class from log4j-core jar"
  ],
  "related_documents": [
    {
      "id": "GHSA-jfh8-c2jp-5v3q",
      "type": "githubexploit",
      "title": "Apache Log4j2 Remote Code Execution (RCE) Vulnerability",
      "published": "2021-12-10T20:15:00.000Z",
      "view_count": 125847,
      "link": "https://vulners.com/githubexploit/GHSA-jfh8-c2jp-5v3q"
    }
  ]
}
```

</details>

<details>
<summary><strong>Click to expand: Security Bulletin Tool Response (<code>BulletinInfoOutput</code>)</strong></summary>

```json
{
  "success": true,
  "error": null,
  "bulletin_id": "GHSA-jfh8-c2jp-5v3q",
  "core_info": {
    "id": "GHSA-jfh8-c2jp-5v3q",
    "published": "2021-12-10T20:15:00.000Z",
    "description": "Apache Log4j2 JNDI features used in configuration, log messages...",
    "title": "Remote code execution in Log4j",
    "type": "githubexploit",
    "href": "https://vulners.com/githubexploit/GHSA-jfh8-c2jp-5v3q"
  },
  "references": [
    "https://github.com/advisories/GHSA-jfh8-c2jp-5v3q",
    "https://logging.apache.org/log4j/2.x/security.html"
  ],
  "related_cves": ["CVE-2021-44228", "CVE-2021-45046", "CVE-2021-45105"]
}
```

</details>

<details>
<summary><strong>Click to expand: Error Response Format</strong></summary>

```json
{
  "success": false,
  "error": "VULNERS_API_KEY not configured. Please set VULNERS_API_KEY environment variable.",
  "cve_id": "CVE-2021-44228",
  "core_info": null,
  "cvss_metrics": null,
  "ssvc_metrics": null,
  "epss_score": null,
  "cwe_classifications": null,
  "cwe_consequences": null,
  "exploitation_status": null,
  "affected_products": null,
  "references": null,
  "related_cves": null,
  "solutions": null,
  "workarounds": null,
  "related_documents": null
}
```

</details>

## Prerequisites

- **Docker**: Required for deployment
- **Vulners API Key**: Get your free API key from [Vulners](https://vulners.com/docs/api_reference/apikey/)

## Docker Deployment

LA-Vulners-MCP is designed exclusively for Docker deployment and supports two transport modes.

### 1. Build the Docker Image

```bash
git clone <repository-url>
cd LA-Vulners-MCP
docker build -t la-vulners-mcp .
```

The build process automatically downloads the latest CAPEC attack patterns data (`1000.xml`) from MITRE for enhanced vulnerability analysis.

### 2. Choose Your Transport Mode

#### Stdio Mode - For Claude Desktop and Cursor

**Use Case**: AI assistants that communicate via standard input/output

**Docker Run Command:**

```bash
docker run -i --rm \
  -e VULNERS_API_KEY=your-vulners-api-key \
  la-vulners-mcp:latest
```

**Claude Desktop Configuration** (`claude_desktop_config.json`):

Go to **Claude > Settings > Developer > Edit Config** and add:

```json
{
  "mcpServers": {
    "LA-Vulners-MCP": {
      "command": "docker",
      "args": [
        "run",
        "-i",
        "--rm",
        "-e",
        "VULNERS_API_KEY=your-vulners-api-key",
        "la-vulners-mcp:latest"
      ]
    }
  }
}
```

**Cursor Configuration** (`~/.cursor/mcp.json`):

Go to **Cursor > Settings > Cursor Settings > MCP > Add new global MCP server** and add:

```json
{
  "mcpServers": {
    "LA-Vulners-MCP": {
      "command": "docker",
      "args": [
        "run",
        "-i",
        "--rm",
        "-e",
        "VULNERS_API_KEY=your-vulners-api-key",
        "la-vulners-mcp:latest"
      ]
    }
  }
}
```

**Optional Debug Mode** (add to `args` array):

```json
"-e", "DEBUG=true"
```

#### HTTP Mode - For CrewAI and MCP Client Frameworks

**Use Case**: MCP frameworks that communicate via HTTP JSON-RPC

**Start HTTP Server:**

Using the helper script:

```bash
export VULNERS_API_KEY=your-vulners-api-key
./run_vulners_mcp.sh
```

Or manually:

```bash
docker run -d \
  -p 8000:8000 \
  --name la-vulners-mcp-http \
  -e MCP_TRANSPORT=http \
  -e VULNERS_API_KEY=your-vulners-api-key \
  la-vulners-mcp:latest
```

The HTTP server will be accessible at: **`http://localhost:8000/mcp`**

**CrewAI/VM-Agent Configuration:**

Create or update your `.env` file:

```bash
VULNERS_MCP_URL=http://localhost:8000/mcp
```

Python code example:

```python
from crewai_tools import MCPServerAdapter

# Configure MCP server connection
mcp_adapter = MCPServerAdapter({
    "url": "http://localhost:8000/mcp",
    "transport": "streamable-http"
})

# Tools are automatically discovered
mcp_tools = mcp_adapter.__enter__()
```

**Server Management:**

```bash
# View logs
docker logs -f la-vulners-mcp-http

# Stop server
docker stop la-vulners-mcp-http

# Restart server
./run_vulners_mcp.sh
```

## Transport Mode Comparison

| Feature | Stdio Mode | HTTP Mode |
|---------|------------|-----------|
| **Use Case** | AI assistants (Claude, Cursor) | MCP frameworks (CrewAI, VM-Agent) |
| **Connection** | Standard input/output | HTTP JSON-RPC endpoint |
| **Container Mode** | Interactive (`-i --rm`) | Detached daemon (`-d`) |
| **Port Binding** | Not required | Port 8000 exposed |
| **Endpoint** | N/A | `http://localhost:8000/mcp` |
| **Configuration** | Default (no env var) | `MCP_TRANSPORT=http` |

## Usage Examples

### With Claude Desktop

After configuring and restarting Claude Desktop, ask questions like:

- "Analyze CVE-2021-44228"
- "What security advisories are related to CVE-2024-1234?"
- "Give me exploitation status for CVE-2023-5678"

![Claude MCP Tool Usage](images/Claude_MCP_Tool_Usage.png)

### With Cursor

After configuring and restarting Cursor, use the MCP tools directly in your development environment.

### With CrewAI

See [VM-Agent](https://github.com/your-repo/VM-Agent) for a complete CrewAI implementation using LA-Vulners-MCP.

## Debug Mode

Enable debug mode for troubleshooting and development:

**For Claude/Cursor** (add to Docker args):

```json
"-e", "DEBUG=true"
```

**For HTTP mode:**

```bash
docker run -d -p 8000:8000 \
  --name la-vulners-mcp-http \
  -e MCP_TRANSPORT=http \
  -e DEBUG=true \
  -e VULNERS_API_KEY=your-vulners-api-key \
  la-vulners-mcp:latest
```

**Debug mode provides:**

- Enhanced logging output for troubleshooting API calls
- Automatic saving of tool responses as `vulners_mcp_output_{CVE-ID}.json` files
- Detailed data processing information

## Example Output Files

The repository includes real-world example outputs from the CVE analysis tool (`vulners_cve_info`) demonstrating the full JSON response structure with actual vulnerability data. These files were generated in debug mode and are useful for:

- **Understanding Data Structure**: See complete, real-world responses with all fields populated
- **Integration Development**: Use as test fixtures when building applications
- **API Exploration**: Review actual vulnerability data without running the server

### Available Examples

| CVE ID | File | Description |
|--------|------|-------------|
| CVE-2025-10585 | `vulners_mcp_output_CVE-2025-10585.json` | Google Chrome V8 Type Confusion vulnerability (19KB) |
| CVE-2025-53770 | `vulners_mcp_output_CVE-2025-53770.json` | Vulnerability example |
| CVE-2025-7775 | `vulners_mcp_output_CVE-2025-7775.json` | Vulnerability example |
| CVE-2025-61882 | `vulners_mcp_output_CVE-2025-61882.json` | Vulnerability example |
| CVE-2025-31205 | `vulners_mcp_output_CVE-2025-31205.json` | Comprehensive example (35KB) |
| CVE-2025-30108 | `vulners_mcp_output_CVE-2025-30108.json` | Minimal example (2KB) |

Each file demonstrates different aspects of the tool's output:

- **CVE-2025-31205** (35KB): Large response with extensive related documents, solutions, and vulnerability chains
- **CVE-2025-10585** (19KB): Medium-sized response with CVSS metrics, CWE analysis, and EPSS scores
- **CVE-2025-30108** (2KB): Minimal response showing the structure for CVEs with limited data

These examples show the actual JSON structure described in the [JSON Output Structure](#json-output-structure) section with real vulnerability intelligence data.

## Architecture

```text
┌─────────────────────────────────────────────────────────────┐
│                    LA-Vulners-MCP Server                    │
│                     (FastMCP 2.0)                           │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌──────────────────┐           ┌──────────────────┐      │
│  │   Stdio Mode     │           │    HTTP Mode     │      │
│  │   (Default)      │           │  (Port 8000)     │      │
│  └────────┬─────────┘           └────────┬─────────┘      │
│           │                              │                 │
│           ├─────────────┬────────────────┤                │
│           │             │                │                 │
│      ┌────▼────┐   ┌───▼────┐      ┌───▼────┐           │
│      │  Tool 1 │   │ Tool 2 │      │ Vulners │           │
│      │ CVE Info│   │Bulletin│      │   API   │           │
│      └─────────┘   └────────┘      └─────────┘           │
└─────────────────────────────────────────────────────────────┘
         │                │                      │
    ┌────▼────┐      ┌───▼────┐           ┌────▼──────┐
    │ Claude  │      │ Cursor │           │  CrewAI   │
    │ Desktop │      │        │           │ VM-Agent  │
    └─────────┘      └────────┘           └───────────┘
```

## Project Structure

```text
LA-Vulners-MCP/
├── vulners_mcp.py              # Main MCP server (FastMCP 2.0)
├── requirements.txt            # Python dependencies
├── Dockerfile                  # Docker configuration
├── .dockerignore               # Docker build exclusions
├── .gitignore                  # Git exclusions
├── .env                        # Environment variables (git-ignored)
├── run_vulners_mcp.sh          # Helper script for HTTP mode
├── LICENSE                     # GNU AGPL v3.0 license
├── README.md                   # This file
├── 1000.xml                    # CAPEC attack patterns data
├── vulners_mcp_output_*.json   # Example CVE analysis outputs (6 files)
└── images/                     # Documentation screenshots
    ├── banner.png
    └── Claude_MCP_Tool_Usage.png
```

## Troubleshooting

### Tools Not Appearing in Claude/Cursor

1. Verify configuration file syntax (valid JSON)
2. Restart the application completely
3. Check that Docker image is built: `docker images | grep la-vulners-mcp`
4. Ensure VULNERS_API_KEY is set in configuration

### HTTP Mode Connection Issues

1. Verify container is running: `docker ps | grep vulners`
2. Check port binding: `lsof -i :8000`
3. Test endpoint: `curl http://localhost:8000/mcp`
4. Review container logs: `docker logs la-vulners-mcp-http`

### Debug Mode Not Working

Ensure `DEBUG` environment variable is set to `true` in your Docker configuration and restart the container.

## Contributing

Contributions are welcome! Please feel free to submit a pull request or open an issue for any enhancements or bug fixes.

## License

This project is licensed under the GNU AFFERO GENERAL PUBLIC LICENSE 3.0. See the [LICENSE](LICENSE) file for more details.

## Acknowledgments

- Built with [FastMCP 2.0](https://github.com/jlowin/fastmcp) by Marvin
- Powered by [Vulners API](https://vulners.com/)
- CAPEC attack patterns from [MITRE](https://capec.mitre.org/)
- Implements the [Model Context Protocol](https://modelcontextprotocol.io) specification
