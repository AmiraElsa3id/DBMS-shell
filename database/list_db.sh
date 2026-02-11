#!/bin/bash

# List Databases

list_databases() {
    print_header "LIST DATABASES"
    
    # Check if databases directory exists
    if [[ ! -d "$DB_ROOT" ]]; then
        echo "No databases found."
        pause
        return
    fi
    
    # List all directories in DB_ROOT
    databases=($(ls -d "$DB_ROOT"/*/ 2>/dev/null | xargs -n 1 basename 2>/dev/null))
    
    if [[ ${#databases[@]} -eq 0 ]]; then
        echo "No databases found."
    else
        echo "Available Databases:"
        echo "-------------------"
        for db in "${databases[@]}"; do
            echo "  - $db"
        done
    fi
    
    pause
}