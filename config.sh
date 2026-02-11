#!/bin/bash

# Configuration file for DBMS

# Get the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Database root directory
DB_ROOT="$SCRIPT_DIR/databases"

# Field separator for data files
FIELD_SEPARATOR="|"

# Supported data types
SUPPORTED_TYPES=("int" "string" "float" "boolean" "date" "email" "url" "phone")

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
GRAY='\033[0;37m'
NC='\033[0m' # No Color
