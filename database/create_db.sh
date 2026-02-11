#!/bin/bash

# Create Database

create_database() {
    print_header "CREATE DATABASE"
    
    read -p "Enter database name: " db_name
    
    # Validate database name
    if ! validate_db_name "$db_name"; then
        echo "Error: Invalid database name. Use alphanumeric and underscore only."
        pause
        return
    fi
    
    # Check if database already exists
    if db_exists "$db_name"; then
        echo "Error: Database '$db_name' already exists."
        pause
        return
    fi
    
    # Create database directory
    mkdir -p "$DB_ROOT/$db_name"
    
    if [[ $? -eq 0 ]]; then
        echo "Success: Database '$db_name' created successfully."
    else
        echo "Error: Failed to create database."
    fi
    
    pause
}