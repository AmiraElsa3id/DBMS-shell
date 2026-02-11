#!/bin/bash

# Update Table

update_table() {
    local db_name="$1"
    
    print_header "UPDATE TABLE"
    
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
    
    # Read primary key
    pk_column=$(head -n 1 "$meta_file" | cut -d: -f2)
    
    # Read column names and types
    col_names=()
    col_types=()
    pk_index=0
    index=0
    
    while IFS=: read -r col_name col_type; do
        if [[ "$col_name" != "PK" ]]; then
            col_names+=("$col_name")
            col_types+=("$col_type")
            if [[ "$col_name" == "$pk_column" ]]; then
                pk_index=$index
            fi
            ((index++))
        fi
    done < "$meta_file"
    
    read -p "Enter $pk_column value to update: " pk_value
    
    # Check if file exists and has data
    if [[ ! -f "$data_file" ]] || [[ ! -s "$data_file" ]]; then
        echo "Error: No data in table."
        pause
        return
    fi
    
    # Find the row
    found=false
    row_to_update=()
    
    while IFS="$FIELD_SEPARATOR" read -r -a row; do
        if [[ "${row[$pk_index]}" == "$pk_value" ]]; then
            found=true
            row_to_update=("${row[@]}")
            break
        fi
    done < "$data_file"
    
    if [[ "$found" == false ]]; then
        echo "Error: No row found with $pk_column = $pk_value."
        pause
        return
    fi
    
    # Show available columns (except primary key)
    echo ""
    echo "Available columns to update:"
    for ((i=0; i<${#col_names[@]}; i++)); do
        if [[ "$i" != "$pk_index" ]]; then
            echo "  - ${col_names[$i]} (${col_types[$i]})"
        fi
    done
    
    read -p "Enter column name to update: " update_col
    
    # Find column index
    update_index=-1
    for ((i=0; i<${#col_names[@]}; i++)); do
        if [[ "${col_names[$i]}" == "$update_col" ]]; then
            update_index=$i
            break
        fi
    done
    
    if [[ "$update_index" == -1 ]]; then
        echo "Error: Column '$update_col' not found."
        pause
        return
    fi
    
    # Don't allow updating primary key
    if [[ "$update_index" == "$pk_index" ]]; then
        echo "Error: Cannot update primary key column."
        pause
        return
    fi
    
    # Get new value
    while true; do
        read -p "Enter new value for $update_col (${col_types[$update_index]}): " new_value
        
        if validate_value "$new_value" "${col_types[$update_index]}"; then
            break
        else
            echo "Error: Invalid value for type ${col_types[$update_index]}."
        fi
    done
    
    # Update the row
    temp_file="$data_file.tmp"
    
    while IFS="$FIELD_SEPARATOR" read -r -a row; do
        if [[ "${row[$pk_index]}" == "$pk_value" ]]; then
            row[$update_index]="$new_value"
        fi
        echo "${row[*]}" | tr ' ' "$FIELD_SEPARATOR" >> "$temp_file"
    done < "$data_file"
    
    mv "$temp_file" "$data_file"
    
    echo ""
    echo "Success: Row updated successfully."
    pause
}