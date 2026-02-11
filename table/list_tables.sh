#!/bin/bash

# List Tables

list_tables() {
    local db_name="$1"
    
    print_header "LIST TABLES"
    
    # Find all .meta files
    tables=($(ls "$DB_ROOT/$db_name"/*.meta 2>/dev/null | xargs -n 1 basename 2>/dev/null | sed 's/.meta$//'))
    
    if [[ ${#tables[@]} -eq 0 ]]; then
        echo "No tables found in database '$db_name'."
    else
        echo "Tables in database '$db_name':"
        echo "----------------------------"
        for table in "${tables[@]}"; do
            echo "  - $table"
        done
    fi
    
    pause
}