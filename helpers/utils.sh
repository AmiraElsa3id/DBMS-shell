#!/bin/bash

# Utility functions

# Print header
print_header() {
    echo ""
    echo "================================"
    echo "$1"
    echo "================================"
}

# Pause and wait for user
pause() {
    echo ""
    read -p "Press Enter to continue..."
}