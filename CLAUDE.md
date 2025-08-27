# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Docker-based environment for Princeton optimization courses (ORF307 and ORF522) that provides a standardized Jupyter Lab environment with optimization packages pre-installed.

## Architecture

- **Docker image**: Based on `quay.io/jupyter/minimal-notebook:python-3.11.7`
- **Main service**: Jupyter Lab server running on port 8888
- **Volume mounting**: User's home directory mounted to `/home/jovyan/work` in container
- **Dependencies**: Optimization packages (JAX, CVXPY, PEPIT, DCCP) and scientific computing libraries

## Development Commands

### Starting the environment
```bash
# Using Docker Compose (recommended)
docker compose up -d

# Direct Docker command (Mac/Linux)
docker run -it --rm -p 8888:8888 -v $HOME:/home/jovyan/work bstellato/optimization-docker:main

# Direct Docker command (Windows)
docker run -v %USERPROFILE%:/home/jovyan/work -p 8888:8888 bstellato/optimization-docker:main
```

### Stopping the environment
```bash
# Using Docker Compose
docker compose down

# Direct Docker
docker ps  # find container name
docker kill <container_name>
```

### Building the image
```bash
docker build --rm --tag bstellato/optimization-docker .
```

## Platform-specific Startup

The repository includes platform-specific startup scripts that automate the Docker Compose workflow:

- **Mac**: `start-jupyter-mac.command` - Shell script that starts Docker Compose and opens browser
- **Windows**: `Start-Jupyter-Windows.bat` - Batch file with equivalent functionality  
- **Linux**: `start-jupyter-linux.desktop` - Desktop entry file

These scripts automatically:
1. Start the Jupyter Lab container in detached mode
2. Open browser to `http://127.0.0.1:8888/lab`
3. Display connection info and shutdown instructions

## Key Files

- `docker-compose.yml`: Service configuration with volume mounting and port mapping
- `Dockerfile`: Multi-stage build installing system packages and Python dependencies
- `requirements.txt`: Python packages focused on optimization and scientific computing
- `README.md`: Complete setup and troubleshooting instructions for students

## Access

- Jupyter Lab URL: `http://127.0.0.1:8888/lab`
- No authentication token required (configured for educational use)
- Files persist in user's home directory via volume mount