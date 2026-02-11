#!/bin/bash

# Select From Table

select_from_table() {
    local db_name="$1"
    
    print_header "SELECT FROM TABLE"
    
    read -p "Enter table name: " table_name
    
    # Check if table exists
    if ! table_exists "$db_name" "$table_name"; then
        echo "Error: Table '$table_name' does not exist."
        pause
        return
    fi
    
    # Read metadata
    meta_file="$DB_ROOT/$db_name/${table_name}.meta"
    data_file="$DB_ROOT/$db_name/${table_name}.data"
    
    # Read column names
    col_names=()
    while IFS=: read -r col_name col_type; do
        if [[ "$col_name" != "PK" ]]; then
            col_names+=("$col_name")
        fi
    done < "$meta_file"
    
    echo ""
    echo "Table: $table_name"
    echo ""
    
    # Print header
    printf "%-15s" "${col_names[@]}"
    echo ""
    printf "%-15s" | tr ' ' '-'
    for ((i=1; i<${#col_names[@]}; i++)); do
        printf "%-15s" | tr ' ' '-'
    done
    echo ""
    
    # Print data rows
    if [[ -f "$data_file" ]] && [[ -s "$data_file" ]]; then
        while IFS="$FIELD_SEPARATOR" read -r -a values; do
            for value in "${values[@]}"; do
                printf "%-15s" "$value"
            done
            echo ""
        done < "$data_file"
    else
        echo "No data found."
    fi
    
    pause
}