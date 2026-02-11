#!/bin/bash

# Create Table

create_table() {
    local db_name="$1"
    
    print_header "CREATE TABLE"
    
    read -p "Enter table name: " table_name
    
    # Validate table name
    if ! validate_table_name "$table_name"; then
        echo "Error: Invalid table name."
        pause
        return
    fi
    
    # Check if table already exists
    if table_exists "$db_name" "$table_name"; then
        echo "Error: Table '$table_name' already exists."
        pause
        return
    fi
    
    # Get number of columns
    read -p "Enter number of columns: " num_cols
    
    if ! [[ "$num_cols" =~ ^[1-9][0-9]*$ ]]; then
        echo "Error: Invalid number of columns."
        pause
        return
    fi
    
    # Arrays to store column information
    col_names=()
    col_types=()
    pk_column=""
    
    # Get column details
    for ((i=1; i<=num_cols; i++)); do
        echo ""
        read -p "Column $i name: " col_name
        
        # Validate column name
        if ! validate_column_name "$col_name"; then
            echo "Error: Invalid column name."
            pause
            return
        fi
        
        # Check for duplicate column names
        for existing_col in "${col_names[@]}"; do
            if [[ "$existing_col" == "$col_name" ]]; then
                echo "Error: Duplicate column name '$col_name'."
                pause
                return
            fi
        done
        
        # Get data type
        echo "Available types: int, string, float"
        read -p "Column $i datatype: " col_type
        
        if ! validate_datatype "$col_type"; then
            echo "Error: Invalid data type. Use: int, string, or float."
            pause
            return
        fi
        
        col_names+=("$col_name")
        col_types+=("$col_type")
    done
    
    # Ask for primary key
    echo ""
    echo "Available columns: ${col_names[*]}"
    read -p "Enter primary key column name: " pk_column
    
    # Validate primary key exists
    pk_found=false
    for col in "${col_names[@]}"; do
        if [[ "$col" == "$pk_column" ]]; then
            pk_found=true
            break
        fi
    done
    
    if [[ "$pk_found" == false ]]; then
        echo "Error: Primary key column '$pk_column' not found."
        pause
        return
    fi
    
    # Create metadata file
    meta_file="$DB_ROOT/$db_name/${table_name}.meta"
    echo "VERSION:1.0" > "$meta_file"
    echo "PK:$pk_column" >> "$meta_file"
    
    for ((i=0; i<${#col_names[@]}; i++)); do
        echo "${col_names[$i]}:${col_types[$i]}" >> "$meta_file"
    done
    
    # Create empty data file
    data_file="$DB_ROOT/$db_name/${table_name}.data"
    touch "$data_file"
    
    echo ""
    echo "Success: Table '$table_name' created successfully."
    pause
}