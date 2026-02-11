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

# Colored print functions
print_success() {
    echo -e "${GREEN}$1${NC}"
}

print_error() {
    echo -e "${RED}$1${NC}"
}

print_warning() {
    echo -e "${YELLOW}$1${NC}"
}

print_info() {
    echo -e "${BLUE}$1${NC}"
}

print_header() {
    echo ""
    echo -e "${CYAN}================================${NC}"
    echo -e "${WHITE}$1${NC}"
    echo -e "${CYAN}================================${NC}"
}