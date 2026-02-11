#!/bin/bash

# Delete From Table

delete_from_table() {
    local db_name="$1"
    
    print_header "DELETE FROM TABLE"
    
    read -p "Enter table name: " table_name
    
    # Check if table exists
    if ! table_exists "$db_name" "$table_name"; then
        print_error "Error: Table '$table_name' does not exist."
        pause
        return
    fi
    
    # Read metadata
    meta_file="$DB_ROOT/$db_name/${table_name}.meta"
    data_file="$DB_ROOT/$db_name/${table_name}.data"
    
    # Read primary key
    pk_column=$(head -n 1 "$meta_file" | cut -d: -f2)
    
    # Find primary key column index
    col_names=()
    pk_index=0
    
    while IFS=: read -r col_name col_type; do
        if [[ "$col_name" != "PK" ]]; then
            col_names+=("$col_name")
            if [[ "$col_name" == "$pk_column" ]]; then
                pk_index=${#col_names[@]}-1
            fi
        fi
    done < "$meta_file"
    
    read -p "Enter $pk_column value to delete: " pk_value
    
    # Check if file exists and has data
    if [[ ! -f "$data_file" ]] || [[ ! -s "$data_file" ]]; then
        print_error "Error: No data in table."
        pause
        return
    fi
    
    # Create temporary file
    temp_file="$data_file.tmp"
    found=false
    
    # Copy all rows except the one to delete
    while IFS="$FIELD_SEPARATOR" read -r -a row; do
        if [[ "${row[$pk_index]}" == "$pk_value" ]]; then
            found=true
        else
            echo "${row[*]}" | tr ' ' "$FIELD_SEPARATOR" >> "$temp_file"
        fi
    done < "$data_file"
    
    if [[ "$found" == true ]]; then
        mv "$temp_file" "$data_file"
        print_success "Success: Row deleted successfully."
    else
        rm -f "$temp_file"
        print_error "Error: No row found with $pk_column = $pk_value."
    fi
    
    pause
}