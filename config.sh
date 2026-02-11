#!/bin/bash

# Configuration file for DBMS

# Get the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Database root directory
DB_ROOT="$SCRIPT_DIR/databases"

# Field separator for data files
FIELD_SEPARATOR="|"

# Supported data types
SUPPORTED_TYPES=("int" "string" "float")
