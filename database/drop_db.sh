#!/bin/bash

# Drop Database

drop_database() {
    print_header "DROP DATABASE"
    
    read -p "Enter database name to drop: " db_name
    
    # Validate database name
    if ! validate_db_name "$db_name"; then
        echo "Error: Invalid database name."
        pause
        return
    fi
    
    # Check if database exists
    if ! db_exists "$db_name"; then
        echo "Error: Database '$db_name' does not exist."
        pause
        return
    fi
    
    # Confirm deletion
    read -p "Are you sure you want to drop database '$db_name'? (yes/no): " confirm
    
    if [[ "$confirm" == "yes" ]]; then
        rm -rf "$DB_ROOT/$db_name"
        echo "Success: Database '$db_name' dropped successfully."
    else
        echo "Operation cancelled."
    fi
    
    pause
}