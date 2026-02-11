#!/bin/bash

# Drop Table

drop_table() {
    local db_name="$1"
    
    print_header "DROP TABLE"
    
    read -p "Enter table name to drop: " table_name
    
    # Validate table name
    if ! validate_table_name "$table_name"; then
        echo "Error: Invalid table name."
        pause
        return
    fi
    
    # Check if table exists
    if ! table_exists "$db_name" "$table_name"; then
        echo "Error: Table '$table_name' does not exist."
        pause
        return
    fi
    
    # Confirm deletion
    read -p "Are you sure you want to drop table '$table_name'? (yes/no): " confirm
    
    if [[ "$confirm" == "yes" ]]; then
        rm -f "$DB_ROOT/$db_name/${table_name}.meta"
        rm -f "$DB_ROOT/$db_name/${table_name}.data"
        echo "Success: Table '$table_name' dropped successfully."
    else
        echo "Operation cancelled."
    fi
    
    pause
}